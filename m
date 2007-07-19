Return-Path: <linux-kernel-owner+w=401wt.eu-S939610AbXGSRDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939610AbXGSRDW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935070AbXGSRDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:03:13 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:48755 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934857AbXGSRDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:03:12 -0400
Date: Thu, 19 Jul 2007 19:03:09 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: MMC/SD Root filesystem suspend/resume problems
Message-ID: <20070719190309.28708be8@poseidon.drzeus.cx>
In-Reply-To: <1184860419.29634.10.camel@localhost.localdomain>
References: <1184860419.29634.10.camel@localhost.localdomain>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007 16:53:39 +0100
Richard Purdie <rpurdie@rpsys.net> wrote:

> Hi Pierre,
> 
> Lots of Linux handhelds use MMC/SD devices as the root file system.
> This has worked quite reliably for many kernel versions. In 2.6.22,
> it seems that if you suspend such a system then resume it, the device
> locks up. Trying to execute anything on the filesystem results in a
> "Permission Denied" message. I did see a message from the MMC
> subsystem saying it had redetected the card. There are also messages
> on the console like "MMC: killing requests for dead queue" each time
> you suspend/resume.
> 

The card is removed when you suspend and readded when you resume.
That's the only safe thing we can do until we get suspend support in
the filesystems.

If you really want to shoot yourself in the foot, there is a Kconfig
option that keeps the card around across the suspend.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
