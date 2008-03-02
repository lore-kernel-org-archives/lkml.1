Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714AbYCBILU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbYCBILU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 03:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbYCBILJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 03:11:09 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:60243 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbYCBILI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 03:11:08 -0500
Date: Sun, 2 Mar 2008 10:09:39 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How do arch/ppc and arch/powerpc differ?
Message-ID: <20080302080939.GG25835@cs181133002.pp.htv.fi>
References: <200803021602.EGJ81261.OJtOFVQFFHOSLM@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200803021602.EGJ81261.OJtOFVQFFHOSLM@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 02, 2008 at 04:02:56PM +0900, Tetsuo Handa wrote:
> Hello.
> 
> According to Documentation/SubmitChecklist,
> ppc64 is a good architecture for cross-compilation checking.
> I've just set up cross compiling environment for ppc64
> using "crossdev -t ppc64" on Gentoo 2007.0 environment.
> 
> Now I'm trying to modify Makefile to build kernel for ppc64.
> I've got a question here.
> 
>   ARCH            ?= powerpc
>   CROSS_COMPILE   ?= powerpc64-unknown-linux-gnu-
> 
> Which keyword ("ppc" or "powerpc") do I need to set for ARCH
> to do cross-compilation checking?

powerpc

> How do they differ?

Documentation/feature-removal-schedule.txt says:

What: The arch/ppc and include/asm-ppc directories
When: Jun 2008
Why:  The arch/powerpc tree is the merged architecture for ppc32 and ppc64
      platforms.  Currently there are efforts underway to port the remaining
      arch/ppc platforms to the merged tree.  New submissions to the arch/ppc
      tree have been frozen with the 2.6.22 kernel release and that tree will
      remain in bug-fix only mode until its scheduled removal.  Platforms
      that are not ported by June 2008 will be removed due to the lack of an
      interested maintainer.
Who:  linuxppc-dev@ozlabs.org


> Regards.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

