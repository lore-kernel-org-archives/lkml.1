Return-Path: <linux-kernel-owner+w=401wt.eu-S1758385AbYGaVdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758385AbYGaVdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 17:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786AbYGaVdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 17:33:23 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:37433 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736AbYGaVdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 17:33:22 -0400
Date: Thu, 31 Jul 2008 23:34:10 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: John Kacur <jkacur@gmail.com>
Cc: linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Change Kbuild message to match default
Message-ID: <20080731213410.GC25921@uranus.ravnborg.org>
References: <200807160031.16323.jkacur@gmail.com> <520f0cf10807260234v64297490l6db807fee0864cc5@mail.gmail.com> <20080730202655.GA12148@uranus.ravnborg.org> <520f0cf10807301623l759baa8ub9c669176107fa85@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520f0cf10807301623l759baa8ub9c669176107fa85@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 01:23:56AM +0200, John Kacur wrote:
> On Wed, Jul 30, 2008 at 10:26 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> > On Sat, Jul 26, 2008 at 11:34:14AM +0200, John Kacur wrote:
> >> On Wed, Jul 16, 2008 at 12:31 AM, jkacur <jkacur@gmail.com> wrote:
> >> > Change the Kbuild "If unsure" message to match the default.
> >> >
> >> > Signed-off-by: John Kacur <jkacur at gmail dot com>
> >> >
> >> > Index: linux-2.6.26/init/Kconfig
> >> > ===================================================================
> >> > --- linux-2.6.26.orig/init/Kconfig
> >> > +++ linux-2.6.26/init/Kconfig
> >> > @@ -522,7 +522,7 @@ config CC_OPTIMIZE_FOR_SIZE
> >> >          Enabling this option will pass "-Os" instead of "-O2" to gcc
> >> >          resulting in a smaller kernel.
> >> >
> >> > -         If unsure, say N.
> >> > +         If unsure, say Y.
> >> >
> >> >  config SYSCTL
> >> >        bool
> >> >
> >>
> >> This seems like a no-brainer to me that the default and the "If
> >> unsure" message should match, any reason you haven't picked-it up?
> >
> > Two reasons:
> >
> > 1) I have not started to look at new patches until now
> >
> >   And this is due to several reasons.
> >   First off I have been without internet for a while.
> >   And secondly I do try to avoid new patches during the
> >   merge window which does not fix merge issues.
> 
> Ok, no problem!
> 
> >
> > 2) I am not convinced that "default y" is really what we want.
> >   What does popular distroes use (aka what gets wide testing?).
> >
> 
> Hmnn, good point, in any case there is an inconsistency here. I can
> only speak for my laptop here running openSUSE 11.0 (X86-64)
> 
> gunzip -c /proc/config.gz | grep CC_OPTIMIZE_FOR_SIZE
> CONFIG_CC_OPTIMIZE_FOR_SIZE=y
> uname -a
> Linux linux-ipxk 2.6.25.11-0.1-default #1 SMP 2008-07-13 20:48:28
> +0200 x86_64 x86_64 x86_64 GNU/Linux

Thanks - I applied your patch.

	Sam

