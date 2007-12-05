Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbXLEMRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbXLEMRi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 07:17:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbXLEMR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 07:17:29 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:48527 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751361AbXLEMR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 07:17:28 -0500
Date: Wed, 5 Dec 2007 13:17:23 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeff Dike <jdike@addtoit.com>, Harvey Harrison <harvey.harrison@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] x86: Unify include/asm-x86/linkage_[32|64].h
Message-ID: <20071205121723.GK15974@stusta.de>
References: <1196801629.10408.26.camel@brick> <20071204213247.GA11216@elte.hu> <1196806868.10408.33.camel@brick> <20071204222717.GA25974@elte.hu> <20071204224543.GH15974@stusta.de> <1196809075.10408.42.camel@brick> <20071204231519.GI15974@stusta.de> <20071205001945.GB10763@c2.user-mode-linux.org> <20071205093139.GJ15974@stusta.de> <20071205101845.GB22792@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071205101845.GB22792@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2007 at 11:18:45AM +0100, Ingo Molnar wrote:
> 
> * Adrian Bunk <bunk@stusta.de> wrote:
> 
> > On Tue, Dec 04, 2007 at 07:19:45PM -0500, Jeff Dike wrote:
> > > On Wed, Dec 05, 2007 at 12:15:19AM +0100, Adrian Bunk wrote:
> > > > UML can't switch to the regparm(3) convention on i386 since it links 
> > > > with userspace code, so if assembler code uses this calling convention 
> > > > we need the C prototype of it annotated accordingly.
> > > 
> > > We're not talking about a global calling convention switch, right?
> > > We're talking about selected functions only, in which case, the fact
> > > that UML links against libc is irrelevant.
> > 
> > The non-UML i386 switched to globally using the regparm(3) calling 
> > convention in 2.6.20.
> 
> maybe i'm a bit dense, but why cannot UML switch to -mregparm=3 too?

The UML kernel is linked against libc...

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

