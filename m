Return-Path: <linux-kernel-owner+w=401wt.eu-S933785AbYBNVGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933785AbYBNVGO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 16:06:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760519AbYBNVF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 16:05:57 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:45286 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760545AbYBNVF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 16:05:57 -0500
Date: Thu, 14 Feb 2008 16:05:14 -0500
Message-Id: <200802142105.m1EL5EOo006085@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] unhide CONFIG_DEBUG_SECTION_MISMATCH 
In-reply-to: Your message of "Thu, 14 Feb 2008 22:00:03 +0100."
             <20080214210003.GF21894@uranus.ravnborg.org> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20080214210003.GF21894@uranus.ravnborg.org>, Sam Ravnborg writes:
> On Thu, Feb 14, 2008 at 03:54:04PM -0500, Erez Zadok wrote:
> > Using: v2.6.25-rc1-120-ge760e71
> > 
> > In a normal compilation, I might this message:
> > 
> > ...
> >   MODPOST vmlinux.o
> > WARNING: modpost: Found 4 section mismatch(es).
> > To see full details build your kernel with:
> > 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> > ...
> > 
> > I can indeed try to re-make, passing CONFIG_DEBUG_SECTION_MISMATCH=y on the
> > command line, but I can't turn on the option in my .config.  That's because
> > the option depends on "UNDEFINED".  (Was that an attempt to "hide" the
> > option?  Why?)  The following small patch allows me to set the option in my
> > .config.
> 
> It was done so on purpose.
> The rationale here is that we yet have too many section mismatch for
> a typical build to pass my "good stomach" test.
> So until we get down on an acceptable level we should not be
> too noisy.
> And I wanted it to be turned off also for allyesconfig builds.
> 
> I hope to spend time on the reaming warnings soon but the
> option will not be enabled until latest next mergewindow.
> 
> You could argue that I could have doen this in better ways
> The present version was just simple.
> 
> 	Sam

Thanks, Sam.  That explains it.  Perhaps a small comment next to the Kconfig
entry might help explain why the option is "hidden" for now, so others won't
bother unhiding it again.

Of course, forcing it on might help people to fix those warnings sooner. :-)

Erez.
