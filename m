Return-Path: <linux-kernel-owner+w=401wt.eu-S1753756AbZK1DEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756AbZK1DEz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 22:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbZK1DEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 22:04:55 -0500
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2284 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbZK1DEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 22:04:54 -0500
X-Greylist: delayed 410 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Nov 2009 22:04:54 EST
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
Subject: Re: [GIT PULL for 2.6.32] V4L/DVB updates
Date: Sat, 28 Nov 2009 03:57:58 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org
References: <4B103CE1.8050303@redhat.com> <200911272240.02930.s.L-H@gmx.de>
In-Reply-To: <200911272240.02930.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911280357.58116.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 November 2009 22:40:01 Stefan Lippers-Hollmann wrote:
> Hi
> 
> On Friday 27 November 2009, Mauro Carvalho Chehab wrote:
> > Hi Linus,
> > 
> > Please pull from:
> >         ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git for_linus
> > 
> > For the following drivers and building fixes:
> > 
> >    - radio-gemtek-pci: fix double mutex_lock
> >    - v4l: add more missing linux/sched.h includes
> >    - soc-camera: properly initialise the device object when reusing
> >    - soc-camera: sh_mobile_ceu_camera: call pm_runtime_disable
> >    - em28xx: fix Reddo DVB-C USB TV Box GPIO
> >    - davinci: remove stray duplicate config pointer
> >    - SMS_SIANO_MDTV should depend on HAS_DMA
> >    - cxusb: Fix hang on DViCO FusionHDTV DVB-T Dual Digital 4 (rev 1)
> >    - sh_mobile_ceu_camera: fix compile warning
> >    - Fix wrong parameter order in memset
> [...]
> 
> Please consider cherry picking the following two patches from Hans 
> Verkuil [1]:
> - add the missing s2250-loader.h
> - s2250 mutex patch	

Good catch. Mauro, can you please add these two as well for 2.6.32? I'm sure
I marked these two as high-prio patches. This staging driver is actively
being used and developed so this regression should be fixed.

Thanks,

	Hans

> 
> or revert the patch which broke compiling go7007-usb (imho it would be 
> better to re-add the 2 externs [2], than throwing away the needed mutex 
> conversion, but it would be an option)
> Commit:	fd9a40da1db372833e1af6397d2f6c94ceff3dad
> 		V4L/DVB (12859): go7007: semaphore -> mutex conversion
> 
> or mark CONFIG_VIDEO_GO7007_USB_S2250_BOARD as BROKEN, as it fails to 
> compile since the afforementioned patch was merged on september 19th (this 
> is a 2.6.31 --> 2.6.32 regression) [2,3].
> 
> Regards
> 	Stefan Lippers-Hollmann
> 
> [1]	http://www.mail-archive.com/linux-media@vger.kernel.org/msg11736.html
> [2]	http://lkml.indiana.edu/hypermail/linux/kernel/0911.1/02303.html
> [3]	http://lkml.indiana.edu/hypermail/linux/kernel/0909.3/00062.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
