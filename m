Return-Path: <linux-kernel-owner+w=401wt.eu-S1753680AbZK3ODp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbZK3ODp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 09:03:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbZK3ODo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 09:03:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733AbZK3ODm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 09:03:42 -0500
Date: Mon, 30 Nov 2009 12:03:32 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org
Subject: Re: [GIT PULL for 2.6.32] V4L/DVB updates
Message-ID: <20091130120332.1512e0c6@pedra>
In-Reply-To: <200911280357.58116.hverkuil@xs4all.nl>
References: <4B103CE1.8050303@redhat.com>
	<200911272240.02930.s.L-H@gmx.de>
	<200911280357.58116.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, 28 Nov 2009 03:57:58 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On Friday 27 November 2009 22:40:01 Stefan Lippers-Hollmann wrote:
> > Hi
> > 
> > On Friday 27 November 2009, Mauro Carvalho Chehab wrote:
> > > Hi Linus,
> > > 
> > > Please pull from:
> > >         ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git for_linus
> > > 
> > > For the following drivers and building fixes:
> > > 
> > >    - radio-gemtek-pci: fix double mutex_lock
> > >    - v4l: add more missing linux/sched.h includes
> > >    - soc-camera: properly initialise the device object when reusing
> > >    - soc-camera: sh_mobile_ceu_camera: call pm_runtime_disable
> > >    - em28xx: fix Reddo DVB-C USB TV Box GPIO
> > >    - davinci: remove stray duplicate config pointer
> > >    - SMS_SIANO_MDTV should depend on HAS_DMA
> > >    - cxusb: Fix hang on DViCO FusionHDTV DVB-T Dual Digital 4 (rev 1)
> > >    - sh_mobile_ceu_camera: fix compile warning
> > >    - Fix wrong parameter order in memset
> > [...]
> > 
> > Please consider cherry picking the following two patches from Hans 
> > Verkuil [1]:
> > - add the missing s2250-loader.h
> > - s2250 mutex patch	
> 
> Good catch. Mauro, can you please add these two as well for 2.6.32? I'm sure
> I marked these two as high-prio patches. This staging driver is actively
> being used and developed so this regression should be fixed.

There were a merge problem when applying those patches at -git. As this is a
staging driver, I opted to just move all patches to linux-next, as there were
no mention on the patch subject mentioned that they are, in fact, fixes.

I'll see what can we do to solve the s2250 compilation breakage.

As Linus didn't merge from this pull request yet, I'll work on a fix, based
on one of the Stefan suggestions, preferably backporting the patches.

-- 

Cheers,
Mauro
