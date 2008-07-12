Return-Path: <linux-kernel-owner+w=401wt.eu-S1753273AbYGLFG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273AbYGLFG3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 01:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750939AbYGLFGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 01:06:23 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:56900 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750844AbYGLFGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 01:06:22 -0400
Date: Sat, 12 Jul 2008 07:06:12 +0200
From: Sebastian Siewior <lkml@ml.breakpoint.cc>
To: Dave Chinner <david@fromorbit.com>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: xfs bug in 2.6.26-rc9
Message-ID: <20080712050612.GA11334@Chamillionaire.breakpoint.cc>
References: <alpine.DEB.1.10.0807110939520.30192@uplift.swm.pp.se> <20080711084248.GU29319@disturbed> <20080711190209.GA7401@Chamillionaire.breakpoint.cc> <20080711232201.GG11558@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080711232201.GG11558@disturbed>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dave Chinner | 2008-07-12 09:22:01 [+1000]:

>I effectively quoted from it:
>
>config XFS_DEBUG
>        bool "XFS Debugging support (EXPERIMENTAL)"
>        depends on XFS_FS && EXPERIMENTAL
>        help
>          Say Y here to get an XFS build with many debugging features,
>          including ASSERT checks, function wrappers around macros,
>          and extra sanity-checking functions in various code paths.
>
>          Note that the resulting code will be HUGE and SLOW, and probably
>          not useful unless you are debugging a particular problem.
>
>          Say N unless you are an XFS developer, or you play one on TV.
>
>> Debug mode is usually
>> noisy, little slower and mostly usefull just to the developers but *I*
>> would not expect to BUG() in the non-fatal case.
>
>What do you expect debug code to do? Asserts are designed to
>drop the machine into a debugger when they fail so the problem can
>be, well, debugged.
Sorry, I haven't read this. Userspace assert() results in abort() so it
sane to bug() in kernel.

>Dave.
Sebastian
