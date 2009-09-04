Return-Path: <linux-kernel-owner+w=401wt.eu-S1756827AbZIDNld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbZIDNld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 09:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755931AbZIDNlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 09:41:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214AbZIDNlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 09:41:31 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090904124604.GA6248@redhat.com>
References: <20090904124604.GA6248@redhat.com> <20090903160514.GA23646@redhat.com> <29983.1252053547@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Roland McGrath <roland@redhat.com>,
       Tom Horsley <tom.horsley@att.net>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH 1/1] exec: do not sleep in TASK_TRACED under ->cred_guard_mutex
Date: Fri, 04 Sep 2009 14:39:12 +0100
Message-ID: <32320.1252071552@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> (Argh. Sorry David, the changelog should have mentioned
>  tracehook_report_exec() more explicitely).
> 
> So, David, do you agree with this patch? Do you think it can go to 2.6.31 ?

Okay, add my Acked-by.  Can I recommend you mention tracehook_report_exec() in
the changelog and then push it to Linus again?

David
