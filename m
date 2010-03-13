Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935028Ab0CMAU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:20:57 -0500
Received: from kroah.org ([198.145.64.141]:60716 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934902Ab0CMAUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:04 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:09 2010
Message-Id: <20100313001508.936807588@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Clemens Ladisch <clemens@ladisch.de>, Jaroslav Kysela <perex@perex.cz>
Subject: [patch 043/123] ALSA: via82xx: add quirk for D1289 motherboard
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Clemens Ladisch <clemens@ladisch.de>

commit bf30a4309d4294d3eca248ea8a20c1c3570f5e74 upstream.

Add a headphones-only quirk for the Fujitsu Siemens D1289.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Reported-and-tested-by: Marc Haber <mh+alsa201002@zugschlus.de>
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/via82xx.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/pci/via82xx.c
+++ b/sound/pci/via82xx.c
@@ -1791,6 +1791,12 @@ static struct ac97_quirk ac97_quirks[] =
 		.type = AC97_TUNE_HP_ONLY
 	},
 	{
+		.subvendor = 0x110a,
+		.subdevice = 0x0079,
+		.name = "Fujitsu Siemens D1289",
+		.type = AC97_TUNE_HP_ONLY
+	},
+	{
 		.subvendor = 0x1019,
 		.subdevice = 0x0a81,
 		.name = "ECS K7VTA3",


