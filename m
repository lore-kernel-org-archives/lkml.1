Return-Path: <linux-kernel-owner+w=401wt.eu-S1755951AbZAMRzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbZAMRzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 12:55:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbZAMRzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 12:55:01 -0500
Received: from mail.ab-net.cz ([82.100.38.6]:57072 "EHLO mail.ab-net.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365AbZAMRzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 12:55:00 -0500
X-Greylist: delayed 1092 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Jan 2009 12:55:00 EST
Message-ID: <496CD114.7060802@email.cz>
Date: Tue, 13 Jan 2009 18:36:20 +0100
From: =?ISO-8859-2?Q?Ji=F8=ED_Burda?= <jburda@email.cz>
User-Agent: Thunderbird 2.0.0.18 (X11/20081205)
MIME-Version: 1.0
To: linux-usb@vger.kernel.org, greg@kroah.com, akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] usb: Nokia 5310 mass-storage not mounting in kernel 2.6.28
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Burda <jburda@email.cz>	

Nokia 5310 mobile with firmware revision 8.32 does not mount as usb mass-storage in kernel 2.6.28 and previous.
This patch solves this problem by increasing firmware revision in drivers/usb/storage/unusual_device.h from 0x0701 to 0x0832.
This bug is recorded in kernel bugzilla as 12367.
Signed-off-by: Jiri Burda <jburda@email.cz>
---
--- linux-2.6.28/drivers/usb/storage/unusual_devs.h.orig	2009-01-13 17:21:24.000000000 +0100
+++ linux-2.6.28/drivers/usb/storage/unusual_devs.h	2009-01-13 19:24:16.000000000 +0100
@@ -182,7 +182,7 @@ UNUSUAL_DEV(  0x0421, 0x0063, 0x0001, 0x
 		US_FL_FIX_CAPACITY ),
 
 /* Patch for Nokia 5310 capacity */
-UNUSUAL_DEV(  0x0421, 0x006a, 0x0000, 0x0701,
+UNUSUAL_DEV(  0x0421, 0x006a, 0x0000, 0x0832,
 		"Nokia",
 		"5310",
 		US_SC_DEVICE, US_PR_DEVICE, NULL,




