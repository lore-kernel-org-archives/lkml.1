Return-Path: <linux-kernel-owner+w=401wt.eu-S1764855AbXKOLDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764855AbXKOLDi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 06:03:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754936AbXKOLDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 06:03:30 -0500
Received: from mail164.messagelabs.com ([216.82.253.131]:10357 "HELO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754864AbXKOLD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 06:03:29 -0500
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-3.tower-164.messagelabs.com!1195124608!13182173!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.21]
Date: Mon, 1 Oct 2007 08:41:50 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH Documentation] use the newc archive format as requested by initramfs
Message-ID: <20071001064150.GA24400@bre-cln-ukleine.digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 15 Nov 2007 11:03:27.0381 (UTC) FILETIME=[2618CC50:01C82777]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a documentation followup to 2e591bbc0d563e12f5a260fbbca0df7d5810910e

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
---
 Documentation/initrd.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/initrd.txt b/Documentation/initrd.txt
index d3dc505..0c48110 100644
--- a/Documentation/initrd.txt
+++ b/Documentation/initrd.txt
@@ -85,7 +85,7 @@ involve special block devices or loopbacks, you merely create a directory on
 disk with the desired initrd content, cd to that directory, and run (as an
 example):
 
-find . | cpio --quiet -c -o | gzip -9 -n > /boot/imagefile.img
+find . | cpio --quiet -H newc -o | gzip -9 -n > /boot/imagefile.img
 
 Examining the contents of an existing image file is just as simple:
 
-- 
1.5.3.2

