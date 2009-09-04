Return-Path: <linux-kernel-owner+w=401wt.eu-S1756577AbZIDLBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577AbZIDLBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 07:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754214AbZIDLBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 07:01:20 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:44067 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200AbZIDLBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 07:01:19 -0400
X-Greylist: delayed 2000 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Sep 2009 07:01:18 EDT
Message-ID: <4AA0E6A5.4020701@grupopie.com>
Date: Fri, 04 Sep 2009 11:06:29 +0100
From: Rui Santos <rsantos@grupopie.com>
Organization: GrupoPIE, Portugal SA
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Roberto De Ioris <roberto@unbit.it>
CC: Linux FB-Devel <linux-fbdev-devel@lists.sourceforge.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] udlfb 2.6.31-rc8-git2: Add support for new resolutions
Content-Type: multipart/mixed;
 boundary="------------010909050706040902020805"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010909050706040902020805
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Add new resolutions to udlfb driver: 800x600, 1360x768, 1366x768,
1600x1200 and 1920x1080.

Signed-off-by: Rui Santos <rsantos@grupopie.com>


--------------010909050706040902020805
Content-Type: text/x-patch;
 name="udlfb-2.6.31-rc8-git2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="udlfb-2.6.31-rc8-git2.patch"

diff -upNr linux-2.6.31-rc8-git2.old/drivers/staging/udlfb/udlfb.h linux-2.6.31-rc8-git2.new/drivers/staging/udlfb/udlfb.h
--- linux-2.6.31-rc8-git2-pie.old/drivers/staging/udlfb/udlfb.h	2009-09-04 10:44:11.000000000 +0100
+++ linux-2.6.31-rc8-git2-pie.new/drivers/staging/udlfb/udlfb.h	2009-09-02 12:16:46.000000000 +0100
@@ -1,7 +1,7 @@
 #ifndef UDLFB_H
 #define UDLFB_H
 
-#define MAX_VMODES	4
+#define MAX_VMODES	9
 #define FB_BPP		16
 
 #define STD_CHANNEL	"\x57\xCD\xDC\xA7\x1C\x88\x5E\x15"	\
@@ -98,31 +98,76 @@ static void dlfb_init_modes(void)
 	memcpy(&dlfb_video_modes[0].unknown3, "\x01\x02\xC8\x19", 4);
 
 	dlfb_video_modes[1].col = 0;
-	memcpy(&dlfb_video_modes[1].hclock, "\x36\x18\xD5\x10", 4);
-	memcpy(&dlfb_video_modes[1].vclock, "\x60\xA9\x7B\x33", 4);
-	memcpy(&dlfb_video_modes[1].unknown1, "\xA1\x2B\x27\x32\xFF\xFF", 6);
-	dlfb_video_modes[1].xres = 1024;
-	memcpy(&dlfb_video_modes[1].unknown2, "\xD9\x9A\xFF\xCA\xFF\xFF", 6);
-	dlfb_video_modes[1].yres = 768;
-	memcpy(&dlfb_video_modes[1].unknown3, "\x04\x03\xC8\x32", 4);
+	memcpy(&dlfb_video_modes[1].hclock, "\x20\x3C\x7A\xC9", 4);
+	memcpy(&dlfb_video_modes[1].vclock, "\x93\x60\xC8\xC7", 4);
+	memcpy(&dlfb_video_modes[1].unknown1, "\x70\x53\xFF\xFF\x21\x27", 6);
+	dlfb_video_modes[1].xres = 800;
+	memcpy(&dlfb_video_modes[1].unknown2, "\x91\x8F\xFF\xFF\xFF\xF2", 6);
+	dlfb_video_modes[1].yres = 600;
+	memcpy(&dlfb_video_modes[1].unknown3, "\x01\x02\x40\x1F", 4);
 
 	dlfb_video_modes[2].col = 0;
-	memcpy(&dlfb_video_modes[2].hclock, "\x98\xF8\x0D\x57", 4);
-	memcpy(&dlfb_video_modes[2].vclock, "\x2A\x55\x4D\x54", 4);
-	memcpy(&dlfb_video_modes[2].unknown1, "\xCA\x0D\xFF\xFF\x94\x43", 6);
-	dlfb_video_modes[2].xres = 1280;
-	memcpy(&dlfb_video_modes[2].unknown2, "\x9A\xA8\xFF\xFF\xFF\xF9", 6);
-	dlfb_video_modes[2].yres = 1024;
-	memcpy(&dlfb_video_modes[2].unknown3, "\x04\x02\x60\x54", 4);
+	memcpy(&dlfb_video_modes[2].hclock, "\x36\x18\xD5\x10", 4);
+	memcpy(&dlfb_video_modes[2].vclock, "\x60\xA9\x7B\x33", 4);
+	memcpy(&dlfb_video_modes[2].unknown1, "\xA1\x2B\x27\x32\xFF\xFF", 6);
+	dlfb_video_modes[2].xres = 1024;
+	memcpy(&dlfb_video_modes[2].unknown2, "\xD9\x9A\xFF\xCA\xFF\xFF", 6);
+	dlfb_video_modes[2].yres = 768;
+	memcpy(&dlfb_video_modes[2].unknown3, "\x04\x03\xC8\x32", 4);
 
 	dlfb_video_modes[3].col = 0;
-	memcpy(&dlfb_video_modes[3].hclock, "\x42\x24\x38\x36", 4);
-	memcpy(&dlfb_video_modes[3].vclock, "\xC1\x52\xD9\x29", 4);
-	memcpy(&dlfb_video_modes[3].unknown1, "\xEA\xB8\x32\x60\xFF\xFF", 6);
-	dlfb_video_modes[3].xres = 1400;
-	memcpy(&dlfb_video_modes[3].unknown2, "\xC9\x4E\xFF\xFF\xFF\xF2", 6);
-	dlfb_video_modes[3].yres = 1050;
-	memcpy(&dlfb_video_modes[3].unknown3, "\x04\x02\x1E\x5F", 4);
+	memcpy(&dlfb_video_modes[3].hclock, "\x98\xF8\x0D\x57", 4);
+	memcpy(&dlfb_video_modes[3].vclock, "\x2A\x55\x4D\x54", 4);
+	memcpy(&dlfb_video_modes[3].unknown1, "\xCA\x0D\xFF\xFF\x94\x43", 6);
+	dlfb_video_modes[3].xres = 1280;
+	memcpy(&dlfb_video_modes[3].unknown2, "\x9A\xA8\xFF\xFF\xFF\xF9", 6);
+	dlfb_video_modes[3].yres = 1024;
+	memcpy(&dlfb_video_modes[3].unknown3, "\x04\x02\x60\x54", 4);
+
+	dlfb_video_modes[4].col = 0;
+	memcpy(&dlfb_video_modes[4].hclock, "\xF8\x42\x9E\x64", 4);
+	memcpy(&dlfb_video_modes[4].vclock, "\xF2\x6C\x28\x0F", 4);
+	memcpy(&dlfb_video_modes[4].unknown1, "\xE8\x61\xFF\xFF\x94\x43", 6);
+	dlfb_video_modes[4].xres = 1360;
+	memcpy(&dlfb_video_modes[4].unknown2, "\x40\x7B\xFF\xFF\xFF\xCA", 6);
+	dlfb_video_modes[4].yres = 768;
+	memcpy(&dlfb_video_modes[4].unknown3, "\x04\x02\xCC\x42", 4);
+
+	dlfb_video_modes[5].col = 0;
+	memcpy(&dlfb_video_modes[5].hclock, "\x19\x1E\x1F\xB0", 4);
+	memcpy(&dlfb_video_modes[5].vclock, "\x93\x60\x40\x7B", 4);
+	memcpy(&dlfb_video_modes[5].unknown1, "\x36\xE8\x27\x32\xFF\xFF", 6);
+	dlfb_video_modes[5].xres = 1366;
+	memcpy(&dlfb_video_modes[5].unknown2, "\x03\xD9\xFF\xFF\xFC\xA7", 6);
+	dlfb_video_modes[5].yres = 768;
+	memcpy(&dlfb_video_modes[5].unknown3, "\x04\x02\x9A\x42", 4);
+
+	dlfb_video_modes[6].col = 0;
+	memcpy(&dlfb_video_modes[6].hclock, "\x42\x24\x38\x36", 4);
+	memcpy(&dlfb_video_modes[6].vclock, "\xC1\x52\xD9\x29", 4);
+	memcpy(&dlfb_video_modes[6].unknown1, "\xEA\xB8\x32\x60\xFF\xFF", 6);
+	dlfb_video_modes[6].xres = 1400;
+	memcpy(&dlfb_video_modes[6].unknown2, "\xC9\x4E\xFF\xFF\xFF\xF2", 6);
+	dlfb_video_modes[6].yres = 1050;
+	memcpy(&dlfb_video_modes[6].unknown3, "\x04\x02\x1E\x5F", 4);
+
+	dlfb_video_modes[7].col = 0;
+	memcpy(&dlfb_video_modes[7].hclock, "\xCF\xA4\x3C\x4E", 4);
+	memcpy(&dlfb_video_modes[7].vclock, "\x55\x73\x71\x2B", 4);
+	memcpy(&dlfb_video_modes[7].unknown1, "\x71\x52\xFF\xFF\xEE\xCA", 6);
+	dlfb_video_modes[7].xres = 1600;
+	memcpy(&dlfb_video_modes[7].unknown2, "\xE2\x57\xFF\xFF\xFF\xF9", 6);
+	dlfb_video_modes[7].yres = 1200;
+	memcpy(&dlfb_video_modes[7].unknown3, "\x04\x02\x90\x7E", 4);
+
+	dlfb_video_modes[8].col = 0;
+	memcpy(&dlfb_video_modes[8].hclock, "\x73\xA6\x28\xB3", 4);
+	memcpy(&dlfb_video_modes[8].vclock, "\x54\xAA\x41\x5D", 4);
+	memcpy(&dlfb_video_modes[8].unknown1, "\x0D\x9F\x32\x60\xFF\xFF", 6);
+	dlfb_video_modes[8].xres = 1920;
+	memcpy(&dlfb_video_modes[8].unknown2, "\x0A\xEA\xFF\xF9\xFF\xFF", 6);
+	dlfb_video_modes[8].yres = 1080;
+	memcpy(&dlfb_video_modes[8].unknown3, "\x04\x02\xE0\x7C", 4);
 }
 
 static char *dlfb_set_register(char *bufptr, uint8_t reg, uint8_t val)

--------------010909050706040902020805--
