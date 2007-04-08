Return-Path: <linux-kernel-owner+w=401wt.eu-S1751959AbXDHTig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbXDHTig (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 15:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbXDHTig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 15:38:36 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:46217 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959AbXDHTif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 15:38:35 -0400
Message-ID: <46194550.30203@drzeus.cx>
Date: Sun, 08 Apr 2007 21:41:04 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Alex Dubov <oakad@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Weird MMC errors: 1 of 2 - bad ocr value
References: <20070314144437.3695.qmail@web36706.mail.mud.yahoo.com>
In-Reply-To: <20070314144437.3695.qmail@web36706.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Dubov wrote:
> Recently, I've obtained a bug report concerning an MMC card. Two problems are described, both
> sporadic.
> Problem 1: illegal ocr value is returned. You may notice, in the non-working case, obviously
> incorrect ocr value (0xffffffff) is returned. The card won't work after this, unless reinserted.
> What, to your opinion, shall we do about it?
> 

I got something similar when there was problem with the power supply. The card
was booting through power it drain from the other pins, but it didn't work
correctly.

Try adding some more delay after you power up in case the controller needs some
time to stabilize.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
