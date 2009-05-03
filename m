Return-Path: <linux-kernel-owner+w=401wt.eu-S1752353AbZECFjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353AbZECFjs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 01:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbZECFjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 01:39:40 -0400
Received: from 1wt.eu ([62.212.114.60]:4232 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbZECFjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 01:39:39 -0400
Date: Sun, 3 May 2009 07:38:23 +0200
From: Willy Tarreau <w@1wt.eu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Tobias Doerffel <tobias.doerffel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Specific support for Intel Atom architecture
Message-ID: <20090503053821.GI570@1wt.eu>
References: <200904301408.09370.tobias.doerffel@gmail.com> <20090430154051.GA3346@elte.hu> <49F9DB70.2050906@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F9DB70.2050906@zytor.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 10:10:08AM -0700, H. Peter Anvin wrote:
> Ingo Molnar wrote:
> >> diff --git a/arch/x86/Makefile_32.cpu b/arch/x86/Makefile_32.cpu
> >> index 80177ec..07a11b0 100644
> >> --- a/arch/x86/Makefile_32.cpu
> >> +++ b/arch/x86/Makefile_32.cpu
> >> @@ -33,6 +33,7 @@ cflags-$(CONFIG_MCYRIXIII)	+= $(call cc-option,-march=c3,-march=i486) $(align)-f
> >>  cflags-$(CONFIG_MVIAC3_2)	+= $(call cc-option,-march=c3-2,-march=i686)
> >>  cflags-$(CONFIG_MVIAC7)		+= -march=i686
> >>  cflags-$(CONFIG_MCORE2)		+= -march=i686 $(call tune,core2)
> >> +cflags-$(CONFIG_MATOM)		+= -march=atom $(call tune,atom)
> >>  
> 
> There should be a fallback option used here rather than requiring a new
> gcc, e.g. something like:
> 
> $(call cc-option,-march=atom,-march=i686)

if it's an in-order architecture, wouldn't it be better to tune for i386
or i486 instead ?

Willy

