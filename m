Return-Path: <linux-kernel-owner+w=401wt.eu-S1758842AbXHKIsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842AbXHKIsz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 04:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754803AbXHKIso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 04:48:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754699AbXHKIsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 04:48:42 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <46BCC26B.6080600@redhat.com>
References: <46BCC26B.6080600@redhat.com> <46BB46B2.60808@redhat.com> <20070809134150.GA14890@shell.boston.redhat.com> <2708.1186737826@redhat.com>
To: Chris Snook <csnook@redhat.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, torvalds@linux-foundation.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org, ak@suse.de,
       heiko.carstens@de.ibm.com, davem@davemloft.net, schwidefsky@de.ibm.com,
       wensong@linux-vs.org, horms@verge.net.au, wjiang@resilience.com,
       cfriesen@nortel.com, zlynx@acm.org, rpjday@mindspring.com,
       jesper.juhl@gmail.com
Subject: Re: [PATCH 6/24] make atomic_read() behave consistently on frv
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Sat, 11 Aug 2007 09:47:51 +0100
Message-ID: <7680.1186822071@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook <csnook@redhat.com> wrote:

> cpu_relax() contains a barrier, so it should do the right thing.  For non-smp
> architectures, I'm concerned about interacting with interrupt handlers.  Some
> drivers do use atomic_* operations.

I'm not sure that actually answers my question.  Why not smp_rmb()?

David
