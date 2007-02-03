Return-Path: <linux-kernel-owner+w=401wt.eu-S1751089AbXBDAZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751089AbXBDAZm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 19:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbXBDAZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 19:25:42 -0500
Received: from vms042pub.verizon.net ([206.46.252.42]:34906 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbXBDAZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 19:25:41 -0500
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Feb 2007 19:25:41 EST
Date: Sat, 03 Feb 2007 18:25:16 -0500
From: Eric Buddington <ebuddington@verizon.net>
Subject: Re: 2.6.20-rc6-mm3 BUG in drm_ioctl with Rage 128 card
In-reply-to: <21d7e9970702031520y503bfa98p43708e2d18a6599f@mail.gmail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: ebuddington@wesleyan.edu, Lee Revell <rlrevell@joe-job.com>,
       linux-kernel@vger.kernel.org,
       Thomas Hellstr?m <thomas@tungstengraphics.com>,
       Dave Jones <davej@redhat.com>
Reply-to: ebuddington@wesleyan.edu
Message-id: <20070203232505.GC4557@pool-71-161-133-234.spfdma.east.verizon.net>
Organization: ECS Labs
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
References: <20070203185407.GA5256@pool-70-109-243-148.wma.east.verizon.net>
 <75b66ecd0702031322k58db9da7l1ae1fc3a9342682b@mail.gmail.com>
 <20070203230945.GA4557@pool-71-161-133-234.spfdma.east.verizon.net>
 <21d7e9970702031520y503bfa98p43708e2d18a6599f@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-Eric-conspiracy: there is no conspiracy
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 04, 2007 at 10:20:29AM +1100, Dave Airlie wrote:
> What AGP chipset do you have? it looks like it might be caused by the
> AGP changes for TTM..

lspci:

00:00.0 Host bridge: Silicon Integrated Systems [SiS] 741/741GX/M741 Host (rev 03)
00:01.0 PCI bridge: Silicon Integrated Systems [SiS] SiS AGP Port (virtual PCI-to-PCI bridge)
00:02.0 ISA bridge: Silicon Integrated Systems [SiS] SiS963 [MuTIOL Media IO] (rev 25)
00:02.1 SMBus: Silicon Integrated Systems [SiS] SiS961/2 SMBus Controller
00:02.5 IDE interface: Silicon Integrated Systems [SiS] 5513 [IDE]
...

-Eric
