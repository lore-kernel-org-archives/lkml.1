Return-Path: <linux-kernel-owner+w=401wt.eu-S1758537AbZIQNDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758537AbZIQNDf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 09:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbZIQNDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 09:03:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37862 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270AbZIQNDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 09:03:33 -0400
Date: Thu, 17 Sep 2009 10:02:58 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Steven Toth <stoth@kernellabs.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PULL] http://www.kernellabs.com/hg/~stoth/saa7164-merge
Message-ID: <20090917100258.2a5269d9@pedra.chehab.org>
In-Reply-To: <4AA08B01.30705@kernellabs.com>
References: <4AA08B01.30705@kernellabs.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 03 Sep 2009 23:35:29 -0400
Steven Toth <stoth@kernellabs.com> escreveu:

> Hello Mauro,
> 
> This patch series adds support for the NXP SAA7164 PCIe A/V bridge used by the 
> Hauppauge HVR-2200 and HVR-2250 series of products. Support is limited to DVB-T 
> / ATSC / QAM digital TV only. The driver has been in development (on and off) 
> for around a year and the KernelLabs saa7164-stable tree (from which this patch 
> set was prepared) has been in testing worldwide since approx May(?) 2009.
> 
> The project page including links for firmware downloads, MythTV and Wiki 
> instructions is here: http://www.kernellabs.com/blog/?page_id=17
> 
> Two general observations with the tree:
> 
> 1. The driver is a little verbose during initial module load, I need to trim a 
> few lines of debug.
> 2. During 64bit compile I have one compile time warning to be addressed.
> 
> Both of these will be resolved shortly and should not stop the driver being 
> merged and made available to a much wider range of testers.
> 
> So, please pull from http://www.kernellabs.com/hg/~stoth/saa7164-merge

> SAA7164: Fix i2c eeprom read errors during load (some boards).
> From: Steven Toth <stoth@kernellabs.com>
> SAA7164: Fix i2c eeprom read errors during load (some boards).
> Priority: normal
> Signed-off-by: Steven Toth <stoth@kernellabs.com>

Please don't repeat the one-line summary as description. There are several cases like the above.

>     -  Add the SAA7164 I2C bus identifier

--- a/linux/include/linux/i2c-id.h      Thu Sep 03 09:06:34 2009 -0300
+++ b/linux/include/linux/i2c-id.h      Sat May 09 12:24:12 2009 -0400

+#define I2C_HW_B_SAA7164        0x010024 /* NXP 7164 based tv cards */

Why? Are you needing to use this constant somewhere? If not, just drop it and
leave the field in blank.

Anyway, I won't delay applying it due to that. I'm committing the series. Please send a fix
later for the i2c-id above mentioned.

Thanks,
Mauro
