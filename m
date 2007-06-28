Return-Path: <linux-kernel-owner+w=401wt.eu-S1761980AbXF1TWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761980AbXF1TWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 15:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763995AbXF1TWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 15:22:18 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:37968 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763520AbXF1TWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 15:22:17 -0400
Message-ID: <46840A66.1010901@drzeus.cx>
Date: Thu, 28 Jun 2007 21:22:14 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Midhun Agnihotram <agnimidhun@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Mounting MMC card
References: <4dde4acb0706261146s5906d8f3vb787d5aecb429116@mail.gmail.com>	 <4dde4acb0706281000p180d0066s11a21afe17336fb4@mail.gmail.com> <4dde4acb0706281008h2241f4c4nef18dc130bfe6fdd@mail.gmail.com>
In-Reply-To: <4dde4acb0706281008h2241f4c4nef18dc130bfe6fdd@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Midhun Agnihotram wrote:
> 
>    How do I access the MMC card data now? If I try to mount it,
> busybox doesnot mount it.
> 
> # mount /dev/mmcblk0p0 /mnt/mmc
> mount: mounting /dev/mmcblk0p0 on /mnt/mmc failed
> 

Have you checked that your device nodes are correct? Since you use busybox I
assume the system is too lightweight to run udev.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
