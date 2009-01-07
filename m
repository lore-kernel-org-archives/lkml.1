Return-Path: <linux-kernel-owner+w=401wt.eu-S1759895AbZAGPgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759895AbZAGPgP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 10:36:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbZAGPf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 10:35:59 -0500
Received: from ms01.sssup.it ([193.205.80.99]:36757 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752161AbZAGPf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 10:35:58 -0500
X-Greylist: delayed 3596 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Jan 2009 10:35:58 EST
Message-ID: <4964BDC6.4090704@evidence.eu.com>
Date: Wed, 07 Jan 2009 15:35:50 +0100
From: Claudio Scordino <claudio@evidence.eu.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: starvik@axis.com, jesper.nilsson@axis.com
CC: dev-etrax@axis.com, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Remove unused variable from Cris driver
Content-Type: multipart/mixed;
 boundary="------------060109060102050307060409"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060109060102050307060409
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi Mikael, hi Jesper,

        can you please commit the trivial patch in attachment to remove
the unused variable "serial_termios" from the crisv10 serial driver ?

Many thanks,

         Claudio

--------------060109060102050307060409
Content-Type: text/x-diff;
 name="0001-Unused-variable-serial_termios-removed.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-Unused-variable-serial_termios-removed.patch"

>From 7a179dcbecf8cae3db0b2b9dbeb18fef34953dcb Mon Sep 17 00:00:00 2001
From: Claudio Scordino <claudio@evidence.eu.com>
Date: Wed, 7 Jan 2009 15:12:43 +0100
Subject: [PATCH 1/1] Unused variable serial_termios removed


Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
---
 drivers/serial/crisv10.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/crisv10.c b/drivers/serial/crisv10.c
index 8b2c619..1fadb03 100644
--- a/drivers/serial/crisv10.c
+++ b/drivers/serial/crisv10.c
@@ -456,7 +456,6 @@ static struct e100_serial rs_table[] = {
 
 #define NR_PORTS (sizeof(rs_table)/sizeof(struct e100_serial))
 
-static struct ktermios *serial_termios[NR_PORTS];
 #ifdef CONFIG_ETRAX_SERIAL_FAST_TIMER
 static struct fast_timer fast_timers[NR_PORTS];
 #endif
-- 
1.5.4.3


--------------060109060102050307060409--
