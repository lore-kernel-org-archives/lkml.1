Return-Path: <linux-kernel-owner+w=401wt.eu-S1751059AbXBOFsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751059AbXBOFsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 00:48:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbXBOFsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 00:48:11 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:50314 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbXBOFsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 00:48:10 -0500
Message-ID: <45D3F41C.3020600@drzeus.cx>
Date: Thu, 15 Feb 2007 06:48:12 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070131)
MIME-Version: 1.0
To: Eugene Ilkov <e.ilkov@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20 mmc: problem with highspeed SD card
References: <e13597370702131746q6a5d8e79i2341f5eb9c59bf6e@mail.gmail.com>
In-Reply-To: <e13597370702131746q6a5d8e79i2341f5eb9c59bf6e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eugene Ilkov wrote:
> I have I/O errors with Transcend SD highspeed card 2GB/150x when it's
> mounted in r/w mode (cardreader on sharp sl-c1000)
> It works well  if I reverse mmcv4 patch commited to 2.6.19-git2
> (http://lkml.org/lkml/2006/10/4/27)

That patch is not the same as you are referencing in the rest of your mail.

> I'm not experienced in mmc, but I figured out that problem is
> somewhere in mmc_read_switch_caps() and when i change cmd.arg value
> from 0x80FFFFF1 to 0x00FFFFF1 it works fine too
> What argument should have SD_SWITCH opcode?
> 

The argument is correct, so I'm guessing that your controller might be a bit
flaky and not handle the new timing. Can you enable MMC_DEBUG and send over the
dmesg?

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
