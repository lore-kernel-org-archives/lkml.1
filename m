Return-Path: <linux-kernel-owner+w=401wt.eu-S1756636AbXKEMY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636AbXKEMY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 07:24:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754368AbXKEMYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 07:24:19 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:55799 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753877AbXKEMYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 07:24:18 -0500
Date: Mon, 5 Nov 2007 13:22:18 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Romano Giannetti <romanol@upcomillas.es>
Cc: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.34-rc1 eat my photo SD card :-(
Message-ID: <20071105132218.495f244e@poseidon.drzeus.cx>
In-Reply-To: <1194259886.6927.9.camel@localhost>
References: <1193918202.8439.7.camel@rukbat>
	<20071102182833.2c055446@poseidon.drzeus.cx>
	<1194168583.10245.15.camel@rukbat>
	<ada8x5ec7oh.fsf@cisco.com>
	<1194259886.6927.9.camel@localhost>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Nov 2007 11:51:26 +0100
Romano Giannetti <romanol@upcomillas.es> wrote:

> 
> and opening the folder in Nautilus:
> 
> Nov  5 09:21:43 rukbat kernel: [ 1654.235333] FAT: Filesystem panic (dev mmcblk0p1)
> Nov  5 09:21:43 rukbat kernel: [ 1654.235893] FAT: Filesystem panic (dev mmcblk0p1)
> Nov  5 09:21:43 rukbat kernel: [ 1654.235915] mmcblk0p1: rw=0, want=575135, limit=245919
> ...ad libitum.
> 

Ok, now this is a bit more telling. The filesystem is indeed corrupt somehow as it references sectors waaaay outside the device (at roughly 280 MB).

Did you partition and format this card in the camera or in Linux?

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
