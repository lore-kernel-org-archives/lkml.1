Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbZLDJmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbZLDJmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 04:42:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbZLDJmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 04:42:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbZLDJmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 04:42:50 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200912040207.09801.vapier@gentoo.org>
References: <200912040207.09801.vapier@gentoo.org> <8bd0f97a0912021329y7be05434wc9c39d383bfb7ce4@mail.gmail.com> <7946.1259761452@redhat.com> <16680.1259863084@redhat.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: dhowells@redhat.com, uclinux-dev@uclinux.org, linux-kernel@vger.kernel.org,
       Greg Ungerer <gerg@uclinux.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       David McCullough <davidm@snapgear.com>
Subject: Re: [uClinux-dev] Re: [PATCH] FDPIC: respect PT_GNU_STACK exec markings when creating NOMMU stack
Date: Fri, 04 Dec 2009 09:40:32 +0000
Message-ID: <31066.1259919632@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger <vapier@gentoo.org> wrote:

> > 	+	flush_icache_range(mm->brk, brk);
> > 		return mm->brk = brk;
> > 	 }
> 
> probably want mm->brk + brk for the second argument

Ummm...  Why?  mm->brk and brk are both addresses - note the return statement
where brk just gets assigned to mm->brk.

David
