Return-Path: <linux-kernel-owner+w=401wt.eu-S1749667AbXBSHGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1749667AbXBSHGW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 02:06:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750696AbXBSHGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 02:06:22 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:53153 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667AbXBSHGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 02:06:21 -0500
Message-ID: <45D94C70.1080802@drzeus.cx>
Date: Mon, 19 Feb 2007 08:06:24 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070131)
MIME-Version: 1.0
To: Alex Dubov <oakad@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Recent and not-so problems with tifm_sd driver
References: <64677.73649.qm@web36711.mail.mud.yahoo.com>
In-Reply-To: <64677.73649.qm@web36711.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Dubov wrote:
> 
> You'll agree, I think, that add_disk in mmc_block_probe issues a lot of requests (reads partition
> table, fs superblocks and such - plenty of room for critical errors). Then, driver's remove method
> will not be called before driver's probe method had finished. So mmc_block is quite involved, even
> though it does not affect the problem's resolution.

I agree that mmc_block's probe method will generate a whole bunch of requests.
But I don't see how that can be called given the scenario you describe.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
