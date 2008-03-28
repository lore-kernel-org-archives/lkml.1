Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbYC1Ld1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbYC1Ld1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 07:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753625AbYC1LdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 07:33:18 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:61914 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753433AbYC1LdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 07:33:17 -0400
Date: Fri, 28 Mar 2008 12:29:25 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pawel Staszewski <pstaszewski@artcom.pl>,
       Christoph Lameter <clameter@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Ben Nizette <bn@niasdigital.com>
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
Message-ID: <20080328122925.3131484c@hskinnemo-gx620.norway.atmel.com>
In-Reply-To: <alpine.LFD.1.00.0803271859280.14670@woody.linux-foundation.org>
References: <200803272353.51901.rjw@sisk.pl>
	<alpine.LFD.1.00.0803271859280.14670@woody.linux-foundation.org>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Mar 2008 11:29:25.0866 (UTC) FILETIME=[FA613CA0:01C890C6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9976
> > Subject		: BUG: 2.6.25-rc1: iptables postrouting setup causes oops
> > Submitter	: Ben Nizette <bn@niasdigital.com>
> > Date		: 2008-02-12 12:46 (45 days old)
> > References	: http://lkml.org/lkml/2008/2/12/148
> > Handled-By	: Haavard Skinnemoen <hskinnemoen@atmel.com>  
> 
> This one seems gone (and was apparently AVR-only):
> 
> http://lkml.org/lkml/2008/2/13/607:
>   "What ever the problem is it isn't immediately apparent in latest git so
>    I guess we'll just have to keep our eyes peeled."

Yes, I haven't been able to reproduce it, so I was going to ask for it
to be removed. I suspect it must be some sort of -rc1 weirdness that
has been fixed by a later commit.

I don't feel good about closing it without knowing what it was, but
since neither Ben nor I can reproduce it anymore, I don't have any
better suggestions.

Haavard
