Return-Path: <linux-kernel-owner+w=401wt.eu-S1756502AbYH2KtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502AbYH2KtA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 06:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753732AbYH2Ksr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 06:48:47 -0400
Received: from vms044pub.verizon.net ([206.46.252.44]:63003 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbYH2Ksq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 06:48:46 -0400
Date: Fri, 29 Aug 2008 06:48:33 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: linux-2.6.27-rc5, new msgs in log
To: linux-kernel@vger.kernel.org
Message-id: <200808290648.34040.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
User-Agent: KMail/1.9.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings;

x86 box, athlon xp-2800, 1 GB ram, built w/o the 4GB switch enabled so 
it is only seeing 8xx megs, new build with that re-enabled in progress.

I have been building the radeon firmware in my kernels since the initial 
patch adding them came out at about rc2 or so, as my build script carries 
my old .config's forward before doing a 'make oldconfig', and by copying 
the patches resultant firmware/radeon tree forward to each new -rcX.

I am now seeing these in the messages file:
Aug 29 01:16:05 coyote kernel: [  363.201194] [drm] wait for fifo failed status : 0x80076100 0x00000000
Aug 29 01:16:05 coyote kernel: [  363.212257] [drm] wait for fifo failed status : 0x80026138 0x00000000
Aug 29 01:22:29 coyote kernel: [  747.797152] [drm] wait for fifo failed status : 0x80066100 0x00000000

That was at bootup time, and 20 minutes ago when I woke the monitor up again:
Aug 29 06:19:32 coyote kernel: [18570.160855] [drm] wait for fifo failed status : 0x80066107 0x00000000
Aug 29 06:20:26 coyote kernel: [18624.592825] [drm] wait for fifo failed status : 0x80066100 0x00000000
Aug 29 06:20:38 coyote kernel: [18636.513621] [drm] wait for fifo failed status : 0x8006610F 0x00000000
Aug 29 06:20:42 coyote kernel: [18640.370596] [drm] wait for fifo failed status : 0x80066107 0x00000000
Aug 29 06:20:49 coyote kernel: [18647.200431] [drm] wait for fifo failed status : 0x8006610F 0x00000000
Aug 29 06:20:53 coyote kernel: [18651.481310] [drm] wait for fifo failed status : 0x80066100 0x00000000
Aug 29 06:21:44 coyote kernel: [18702.575087] [drm] wait for fifo failed status : 0x8006610F 0x00000000
Aug 29 06:21:49 coyote kernel: [18707.424341] [drm] wait for fifo failed status : 0x80076100 0x00000000
Aug 29 06:21:58 coyote kernel: [18716.581872] [drm] wait for fifo failed status : 0x80066107 0x00000000
Aug 29 06:22:28 coyote kernel: [18745.979819] [drm] wait for fifo failed status : 0x80066107 0x00000000

Do I have a problem or has the driver just been made noisier?

Thanks.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Nothing ever becomes real until it is experienced.
- John Keats
