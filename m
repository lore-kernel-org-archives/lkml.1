Return-Path: <linux-kernel-owner+w=401wt.eu-S933501AbZDHPio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933501AbZDHPio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 11:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763636AbZDHPiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 11:38:23 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1079 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764566AbZDHPiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 11:38:21 -0400
Subject: Re: [PATCH 02/10] MAINTAINERS - Add file patterns
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090408111344.56818f9e@pedra.chehab.org>
References: <1239167872-8179-1-git-send-email-joe@perches.com>
	 <1239167872-8179-3-git-send-email-joe@perches.com>
	 <20090408111344.56818f9e@pedra.chehab.org>
Content-Type: text/plain
Date: Wed, 08 Apr 2009 08:35:49 -0700
Message-Id: <1239204949.32726.37.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-08 at 11:13 -0300, Mauro Carvalho Chehab wrote:
> IMO, we should add a more generic entry to cover both. Something like:
> 
> MEDIA INPUT INFRASTRUCTURE (V4L/DVB)
> P:	Mauro Carvalho Chehab
> M:	mchehab@infradead.org
> L:	linux-media@vger.kernel.org
> W:	http://linuxtv.org
> T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
> S:	Maintained
> F:	drivers/media

Perhaps:

commit 5c32246e24b601e3fbb4bb7d430a5cf4d3851ad5
Author: Joe Perches <joe@perches.com>
Date:   Wed Apr 8 08:34:04 2009 -0700

    MAINTAINERS - Coalesce sections "DVB" and "Video for Linux"
    
    Creating new section MEDIA INPUT INFRASTRUCTURE
    
    Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |   40 +++++++++++++++-------------------------
 1 files changed, 15 insertions(+), 25 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index d6979e6..34c7903 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1842,17 +1842,6 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/wan/dscc4.c
 
-DVB SUBSYSTEM AND DRIVERS
-P:	LinuxTV.org Project
-M:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
-S:	Maintained
-F:	Documentation/dvb/
-F:	drivers/media/dvb/
-F:	drivers/media/common/saa7146*.c
-F:	include/linux/dvb/
-
 DZ DECSTATION DZ11 SERIAL DRIVER
 P:	Maciej W. Rozycki
 M:	macro@linux-mips.org
@@ -3625,6 +3614,21 @@ S:	Maintained
 F:	Documentation/hwmon/max6650
 F:	drivers/hwmon/max6650.c
 
+MEDIA INPUT INFRASTRUCTURE (V4L/DVB)
+P:	Mauro Carvalho Chehab
+M:	mchehab@infradead.org
+P:	LinuxTV.org Project
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+S:	Maintained
+F:	Documentation/dvb/
+F:	Documentation/video4linux/
+F:	drivers/media/
+F:	include/media/
+F:	include/linux/dvb/
+F:	include/linux/videodev*.h
+
 MEGARAID SCSI DRIVERS
 P:	Neela Syam Kolli
 M:	megaraidlinux@lsi.com
@@ -6007,20 +6011,6 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/via-velocity.*
 
-VIDEO FOR LINUX (V4L)
-P:	Mauro Carvalho Chehab
-M:	mchehab@infradead.org
-L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
-S:	Maintained
-F:	Documentation/video4linux/
-F:	drivers/media/video/
-F:	drivers/media/radio/
-F:	include/linux/videodev.h
-F:	include/linux/videodev2.h
-F:	include/media/
-
 VLAN (802.1Q)
 P:	Patrick McHardy
 M:	kaber@trash.net


