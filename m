Return-Path: <linux-kernel-owner+w=401wt.eu-S1756724AbZBRU4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724AbZBRU4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 15:56:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbZBRU4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 15:56:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43880 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572AbZBRU4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 15:56:44 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: i915 regression in 2.6.29-rc5
Date: Wed, 18 Feb 2009 21:56:19 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: ZhangRui <rui.zhang@intel.com>, dri_devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
References: <1234927467.4707.15.camel@rzhang-desktop> <200902180953.50799.jbarnes@virtuousgeek.org>
In-Reply-To: <200902180953.50799.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902182156.20140.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 February 2009, Jesse Barnes wrote:
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
> Note to Rafael: this is not a regression from 2.6.28 since the KMS code is new 
> with 2.6.29.

Yes, I know.  It's already been reported for a couple of times. ;-)

Thanks,
Rafael
