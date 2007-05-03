Return-Path: <linux-kernel-owner+w=401wt.eu-S1031241AbXECMfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031241AbXECMfz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 08:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031240AbXECMfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 08:35:55 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:53063 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031241AbXECMfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 08:35:53 -0400
X-Originating-Ip: 72.143.66.196
Date: Thu, 3 May 2007 08:35:24 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: "Antonino A. Daplas" <adaplas@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: dead CONFIG_ variables:   drivers/video/
In-Reply-To: <1178193844.4606.64.camel@daplas>
Message-ID: <Pine.LNX.4.64.0705030833560.2223@localhost.localdomain>
References: <Pine.LNX.4.64.0705030638270.380@localhost.localdomain>
 <1178193844.4606.64.camel@daplas>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2007, Antonino A. Daplas wrote:

> On Thu, 2007-05-03 at 06:40 -0400, Robert P. J. Day wrote:
> > $ ../dead_config.sh drivers/video
> > ========== FB_68328_INVERT ==========
> > drivers/video/68328fb.c:53:#if defined(CONFIG_FB_68328_INVERT)
>
> Can be made part of Kconfig, I think
>
> > ========== FB_AU1200_DEVS ==========
> > drivers/video/au1200fb.c:52:#ifndef CONFIG_FB_AU1200_DEVS
> > drivers/video/au1200fb.c:53:#define CONFIG_FB_AU1200_DEVS 4
> > drivers/video/au1200fb.c:160:static struct au1200fb_device _au1200fb_devices[CONFIG_FB_AU1200_DEVS];
> > drivers/video/au1200fb.c:714:   for (i = 0; i < CONFIG_FB_AU1200_DEVS; ++i) {
> > drivers/video/au1200fb.c:1635:  for (plane = 0; plane < CONFIG_FB_AU1200_DEVS; ++plane) {
> > drivers/video/au1200fb.c:1730:  for (plane = 0; plane < CONFIG_FB_AU1200_DEVS; ++plane)
> > drivers/video/au1200fb.c:1850:                  for (plane = 0; plane < CONFIG_FB_AU1200_DEVS; ++plane)         {
>
> Not sure about this one.
>
> > ========== FB_MATROX_32MB ==========
> > drivers/video/matrox/matroxfb_base.c:307:#ifdef CONFIG_FB_MATROX_32MB
> > drivers/video/matrox/matroxfb_base.c:327:#ifdef CONFIG_FB_MATROX_32MB
> > drivers/video/matrox/matroxfb_base.c:339:#ifdef CONFIG_FB_MATROX_32MB
> > drivers/video/matrox/matroxfb_base.c:1342:#ifdef CONFIG_FB_MATROX_32MB
> > drivers/video/matrox/matroxfb_base.c:1619:#ifdef CONFIG_FB_MATROX_32MB
> > drivers/video/matrox/matroxfb_DAC1064.c:1053:#ifdef CONFIG_FB_MATROX_32MB
> > drivers/video/matrox/matroxfb_base.h:58:#define CONFIG_FB_MATROX_32MB
> > drivers/video/matrox/matroxfb_base.h:466:#ifdef CONFIG_FB_MATROX_32MB
>
> This needs to be part of Kconfig.
>
> > ========== FB_NVIDIA_DEBUG ==========
> > drivers/video/nvidia/nvidia.c:40:#undef CONFIG_FB_NVIDIA_DEBUG
> > drivers/video/nvidia/nvidia.c:41:#ifdef CONFIG_FB_NVIDIA_DEBUG
> > drivers/video/nvidia/nvidia.c:50:#ifdef CONFIG_FB_NVIDIA_DEBUG
>
> False positive, may be renamed.
>
> > ========== FB_SOFT_CURSOR ==========
> > drivers/video/sis/sis_main.c:1906:#ifdef CONFIG_FB_SOFT_CURSOR
>
> This is dead, FB_SOFT_CURSOR is truly gone.
>
> Thanks.


um ... just so there's no misunderstanding, *i* don't plan on fixing
any of this, i'm just running the script and reporting it.  i'm
assuming the respective maintainers can take it from here.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
