Return-Path: <linux-kernel-owner+w=401wt.eu-S1763644AbXGUK5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763644AbXGUK5f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 06:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759100AbXGUK51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 06:57:27 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:40330 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758957AbXGUK50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 06:57:26 -0400
Date: Sat, 21 Jul 2007 12:56:49 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC, Announce] Unified x86 architecture, arch/x86
Message-ID: <20070721105649.GG3801@stusta.de>
References: <1184970779.4012.38.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1184970779.4012.38.camel@chaos>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for doing this, it's definitely the way to go.

After a quick look over it, I noted a small mistake:
After the arch/x86_64/kernel/Makefile -> arch/x86/kernel/Makefile_64 
transition, the three foo-$(subst m,y,$(CONFIG_BAR)) got replaced with
foo-$(CONFIG_BAR).

Although the subst's look fishy, such changes shouldn't be part of the 
architecture merge.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

