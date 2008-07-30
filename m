Return-Path: <linux-kernel-owner+w=401wt.eu-S1761164AbYGaATI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761164AbYGaATI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761350AbYGaASL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:18:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:37101 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762729AbYGaASJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:18:09 -0400
Date: Wed, 30 Jul 2008 16:59:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Hans Verkuil <hverkuil@xs4all.nl>,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [patch 38/62] V4L: cx18: Upgrade to newer firmware & update
	documentation
Message-ID: <20080730235913.GL12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="v4l-cx18-upgrade-to-newer-firmware-update-documentation.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Hans Verkuil <hverkuil@xs4all.nl>

(cherry picked from commit 1a3932e0ed9ca46db2b76ce067e4ebaf04d91ea1)

V4L: cx18: Upgrade to newer firmware & update cx18 documentation

Conexant graciously gave us permission to redistribute the
firmware. Update the documentation where the firmware can be
downloaded.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/video4linux/cx18.txt       |   12 +++---------
 drivers/media/video/cx18/cx18-firmware.c |    2 +-
 2 files changed, 4 insertions(+), 10 deletions(-)

--- a/Documentation/video4linux/cx18.txt
+++ b/Documentation/video4linux/cx18.txt
@@ -23,14 +23,8 @@ encoder chip:
 
 Firmware:
 
-The firmware needs to be extracted from the Windows Hauppauge HVR-1600
-driver, available here:
+You can obtain the firmware files here:
 
-http://hauppauge.lightpath.net/software/install_cd/hauppauge_cd_3.4d1.zip
+http://dl.ivtvdriver.org/ivtv/firmware/cx18-firmware.tar.gz
 
-Unzip, then copy the following files to the firmware directory
-and rename them as follows:
-
-Drivers/Driver18/hcw18apu.rom -> v4l-cx23418-apu.fw
-Drivers/Driver18/hcw18enc.rom -> v4l-cx23418-cpu.fw
-Drivers/Driver18/hcw18mlC.rom -> v4l-cx23418-dig.fw
+Untar and copy the .fw files to your firmware directory.
--- a/drivers/media/video/cx18/cx18-firmware.c
+++ b/drivers/media/video/cx18/cx18-firmware.c
@@ -90,7 +90,7 @@
 #define CX18_DSP0_INTERRUPT_MASK     	0xd0004C
 
 /* Encoder/decoder firmware sizes */
-#define CX18_FW_CPU_SIZE 		(174716)
+#define CX18_FW_CPU_SIZE 		(158332)
 #define CX18_FW_APU_SIZE 		(141200)
 
 #define APU_ROM_SYNC1 0x6D676553 /* "mgeS" */

-- 
