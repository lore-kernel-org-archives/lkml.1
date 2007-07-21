Return-Path: <linux-kernel-owner+w=401wt.eu-S941491AbXGUPV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941491AbXGUPV6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940878AbXGUPNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:13:30 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38639 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S940898AbXGUPN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:13:28 -0400
Subject: Re: [RFC, Announce] Unified x86 architecture, arch/x86
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <ak@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Chris Wright <chrisw@sous-sol.org>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <200707210737.59552.ak@suse.de>
References: <1184970779.4012.38.camel@chaos> <200707210737.59552.ak@suse.de>
Content-Type: text/plain
Organization: Intel International BV
Date: Sat, 21 Jul 2007 08:11:56 -0700
Message-Id: <1185030716.2714.5.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Besides radical file movements like this are bad anyways. They cause
> a big break in patchkits and forward/backwards porting that doesn't 
> really help anybody.

Sorry Andi but I strongly disagree with your disapproval of this.


for existing out of tree patches it's not a big break, it's one sed
script away (until consolidation happens).

For distro backports... well that's a distro problem; the distros get
paid to do that work by their customers. We really can't hold back
mainline progress for that....

Having one tree is a lot of progress; it means we (Intel and the rest of
the kernel community) only have to add features, bugfixes and quirks to
one place. It means testing is shared. It means feature sets are shared.

The only argument against is "but there are quirks in the old one that I
don't want to see".. well Thomas solves that by having a clean way to do
per 32/64 files for the few cases where it's needed.


-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

