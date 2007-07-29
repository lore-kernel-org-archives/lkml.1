Return-Path: <linux-kernel-owner+w=401wt.eu-S934602AbXG2StX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934602AbXG2StX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 14:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932726AbXG2StO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 14:49:14 -0400
Received: from emerald.lightlink.com ([205.232.34.14]:7189 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933042AbXG2StN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 14:49:13 -0400
Date: Sun, 29 Jul 2007 14:45:31 -0400
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Cc: Adrian Bunk <bunk@stusta.de>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [2.6 patch] make abituguru3_read_increment_offset() static
Message-ID: <20070729184531.GB31314@jupiter.solarsys.private>
References: <20070729145701.GJ16817@stusta.de> <46ACBB8E.9080302@hhs.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46ACBB8E.9080302@hhs.nl>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi:

* Hans de Goede <j.w.r.degoede@hhs.nl> [2007-07-29 18:08:46 +0200]:
> Adrian Bunk wrote:
> >abituguru3_read_increment_offset() can become static.
> >
> >Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> Looks good, good catch.
> 
> Acked-by: Hans de Goede <j.w.r.degoede@hhs.nl>
> 
> >
> >---
> >--- linux-2.6.23-rc1-mm1/drivers/hwmon/abituguru3.c.old	2007-07-26 
> >08:56:33.000000000 +0200
> >+++ linux-2.6.23-rc1-mm1/drivers/hwmon/abituguru3.c	2007-07-26 
> >08:57:00.000000000 +0200
> >@@ -691,8 +691,9 @@
> > 
> > /* Sensor settings are stored 1 byte per offset with the bytes
> >    placed add consecutive offsets. */
> >-int abituguru3_read_increment_offset(struct abituguru3_data *data, u8 
> >bank,
> >-	u8 offset, u8 count, u8 *buf, int offset_count)
> >+static int abituguru3_read_increment_offset(struct abituguru3_data *data,
> >+					    u8 bank, u8 offset, u8 count,
> >+					    u8 *buf, int offset_count)
> > {
> > 	int i, x;
> > 
> >

Applied to hwmon-2.6.git/testing, thanks.

-- 
Mark M. Hoffman
mhoffman@lightlink.com

