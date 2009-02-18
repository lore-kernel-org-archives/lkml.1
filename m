Return-Path: <linux-kernel-owner+w=401wt.eu-S1755934AbZBRX35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbZBRX35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 18:29:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751626AbZBRX3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 18:29:49 -0500
Received: from mout1.freenet.de ([195.4.92.91]:49824 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbZBRX3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 18:29:48 -0500
From: Karsten Wiese <fzu@wemgehoertderstaat.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: i915 regression in 2.6.29-rc5
Date: Thu, 19 Feb 2009 00:29:36 +0100
User-Agent: KMail/1.9.9
Cc: ZhangRui <rui.zhang@intel.com>, dri_devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <1234927467.4707.15.camel@rzhang-desktop> <200902180953.05364.jbarnes@virtuousgeek.org>
In-Reply-To: <200902180953.05364.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902190029.36808.fzu@wemgehoertderstaat.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 18. Februar 2009 schrieb Jesse Barnes:
> On Tuesday, February 17, 2009 7:24 pm ZhangRui wrote:
> > Hi, all,
> >
> > I got an i915 failure in 2.6.29-rc5.
> >
> > problem description: the screen doesn't come back after suspend/resume.
> > A workaround is to boot with "nomodesetting".
> >
> > I got this error message during i915 driver load time,
> > [   22.606749] mtrr: type mismatch for e0000000,10000000 old: write-back
> > new: write-combining [   22.606752] [drm] MTRR allocation failed
> > [   22.606753] .  Graphics performance may suffer.
> >
> > and this during s3 suspend,
> > [ 1093.793257] PM: Syncing filesystems ... done.
> > [ 1093.797692] PM: Preparing system for mem sleep
> > [ 1094.119502] [drm:i915_get_vblank_counter] *ERROR* trying to get vblank
> > count for disabled pipe 1 [ 1094.514290] Freezing user space processes ...
> > (elapsed 0.00 seconds) done. [ 1094.514726] Freezing remaining freezable
> > tasks ... (elapsed 0.02 seconds) done.
> >
> > the problem seems to be related with commit
> > 9880b7a527ffbb52f65c2de0a8d4eea86e24775e
> 
> I posted a test patch for this problem (among others related to KMS 
> suspend/resume), care to give it a try?
> 
> http://lists.freedesktop.org/archives/intel-gfx/2009-February/001406.html

Same dmesg entries here. Also PC sometimes hangs at start after attached
analog-monitor switches to "no signal", when normally X11's cursor shows. 

Patch makes no difference to dmesg entries.


thanks,
Karsten
