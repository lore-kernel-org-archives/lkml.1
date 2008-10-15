Return-Path: <linux-kernel-owner+w=401wt.eu-S1752432AbYJOFUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbYJOFUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 01:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbYJOFU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 01:20:28 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:54170 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbYJOFU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 01:20:28 -0400
Date: Wed, 15 Oct 2008 08:20:26 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>, lethal@linux-sh.org,
       linux-sh@vger.kernel.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, Magnus Damm <damm@igel.co.jp>
Subject: Re: [PATCH] soc-camera: fix compile breakage on SH
Message-ID: <20081015052026.GC20183@cs181140183.pp.htv.fi>
References: <20081014183936.GB4710@cs181140183.pp.htv.fi> <Pine.LNX.4.64.0810142335400.10458@axis700.grange> <20081015033303.GC4710@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081015033303.GC4710@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 06:33:03AM +0300, Adrian Bunk wrote:
> On Tue, Oct 14, 2008 at 11:53:37PM +0200, Guennadi Liakhovetski wrote:
> > Fix Migo-R compile breakage caused by incomplete merge.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > 
> > ---
> > 
> > Hi Adrian,
> 
> Hi Guennadi,
> 
> > please see, if the patch below fixes it. Completely untested. Magnus, 
> > could you please verify if it also works (of course, if it at least 
> > compiles:-)) If it doesn't, please fix it along these lines, if it suits 
> > your needs.
> >...
> 
> it does compile.
>...

But it causes compile breakage elsewhere:

<--  snip  -->

...
  CC      drivers/media/video/soc_camera_platform.o
drivers/media/video/soc_camera_platform.c: In function ‘soc_camera_platform_init’:
drivers/media/video/soc_camera_platform.c:49: error: ‘struct soc_camera_platform_info’ has no member named ‘power’
drivers/media/video/soc_camera_platform.c:50: error: ‘struct soc_camera_platform_info’ has no member named ‘power’
drivers/media/video/soc_camera_platform.c: In function ‘soc_camera_platform_release’:
drivers/media/video/soc_camera_platform.c:59: error: ‘struct soc_camera_platform_info’ has no member named ‘power’
drivers/media/video/soc_camera_platform.c:60: error: ‘struct soc_camera_platform_info’ has no member named ‘power’
make[4]: *** [drivers/media/video/soc_camera_platform.o] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

