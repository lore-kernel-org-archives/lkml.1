Return-Path: <linux-kernel-owner+w=401wt.eu-S1750701AbXBKPkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750701AbXBKPkv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 10:40:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750704AbXBKPkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 10:40:51 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:51290 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701AbXBKPku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 10:40:50 -0500
Message-ID: <45CF3904.5070401@drzeus.cx>
Date: Sun, 11 Feb 2007 16:40:52 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070131)
MIME-Version: 1.0
To: Brad Campbell <brad@wasp.net.au>
CC: Alex Dubov <oakad@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: Recent and not-so problems with tifm_sd driver - one more
References: <113489.35158.qm@web36703.mail.mud.yahoo.com> <45CDC22B.6040408@drzeus.cx> <45CEB1C9.5010103@wasp.net.au>
In-Reply-To: <45CEB1C9.5010103@wasp.net.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Brad Campbell wrote:
> 
> I've tested both with and without CONFIG_SYSFS_DEPRECATED on, both fail
> the same way.
> hald reports that the device has no parent and decides to ignore it.
> 

Works fine here. The device tree is:

/sys/devices/pnp0/00:02/mmc0/mmc0:0001/block:mmcblk0/mmcblk0p1/

and hal correctly shows the same structure.

> I've also tested both combinations against hal from ubuntu 6.06LTS and a
> more recent version
> 
> brad@bklaptop2:~$ hald --version
> HAL package version: 0.5.8.1
> 

I'm using 0.5.9 here, but CONFIG_SYSFS_DEPRECATED should make it work with any
ancient version of hal.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
