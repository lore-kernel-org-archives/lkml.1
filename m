Return-Path: <linux-kernel-owner+w=401wt.eu-S1757662AbYBQUNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662AbYBQUNF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 15:13:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757355AbYBQUMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 15:12:20 -0500
Received: from ns2.g-housing.de ([81.169.133.75]:43278 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755813AbYBQUMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 15:12:18 -0500
Date: Sun, 17 Feb 2008 21:11:59 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: Sergio Luis <sergio@larces.uece.br>
cc: Thomas Gleixner <tglx@linutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [build bug] lguest build failure: drivers/lguest/x86/switcher_32.S:(.text+0x3815f8):
 undefined reference to `LGUEST_PAGES_regs_trapnum'
In-Reply-To: <47B83F90.7000203@larces.uece.br>
Message-ID: <alpine.DEB.1.00.0802172109590.6469@sheep.housecafe.de>
References: <20080201124520.GA29900@elte.hu> <20080201170551.GA3825@elte.hu> <200802040711.11280.rusty@rustcorp.com.au> <alpine.LFD.1.00.0802171451060.7583@apollo.tec.linutronix.de> <47B83F90.7000203@larces.uece.br>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Feb 2008, Sergio Luis wrote:
> It doesn't fix the problem totally. If we select
> Virtualization->Linux hypervisor example code (CONFIG_LGUEST)
> as a module, we will get the same build errors,

Confirmed, the build errors persist with CONFIG_LGUEST=m and Rusty's patch 
applied.

thanks,
Christian.
-- 
BOFH excuse #283:

Lawn mower blade in your fan need sharpening
