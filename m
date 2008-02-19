Return-Path: <linux-kernel-owner+w=401wt.eu-S1757329AbYBSVVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbYBSVVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 16:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbYBSVVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 16:21:08 -0500
Received: from ns2.g-housing.de ([81.169.133.75]:55512 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554AbYBSVVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 16:21:07 -0500
Date: Tue, 19 Feb 2008 22:20:49 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: Sergio Luis <sergio@larces.uece.br>
cc: Thomas Gleixner <tglx@linutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [build bug] lguest build failure: drivers/lguest/x86/switcher_32.S:(.text+0x3815f8):
 undefined reference to `LGUEST_PAGES_regs_trapnum'
In-Reply-To: <47BA0486.7000508@larces.uece.br>
Message-ID: <alpine.DEB.1.00.0802182344330.6469@sheep.housecafe.de>
References: <20080201124520.GA29900@elte.hu> <20080201170551.GA3825@elte.hu> <200802040711.11280.rusty@rustcorp.com.au> <alpine.LFD.1.00.0802171451060.7583@apollo.tec.linutronix.de> <47B83F90.7000203@larces.uece.br> <alpine.DEB.1.00.0802172109590.6469@sheep.housecafe.de>
 <47B8D99A.3020202@larces.uece.br> <47B8DFD8.6040602@larces.uece.br> <alpine.DEB.1.00.0802182305590.6469@sheep.housecafe.de> <47BA0486.7000508@larces.uece.br>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Feb 2008, Sergio Luis wrote:
> if you select Y here it will prompt you about the lguest
> hypervisor, the code in question, the one you want to build, and you 
> will then be able to select it as a module, if you want, or built-in 
> into the kernel.

Ah, thanks for the clarification. And yes, after applying your patch, 
compiling succeeds.

C.
-- 
BOFH excuse #412:

Radial Telemetry Infiltration
