Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbYIED2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbYIED2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 23:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbYIED2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 23:28:34 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:25794 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbYIED2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 23:28:33 -0400
Date: Thu, 4 Sep 2008 20:28:13 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, tiwai@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: Tree for September 4 (PATCH: SND_USB)
Message-Id: <20080904202813.4a6d9ca2.randy.dunlap@oracle.com>
In-Reply-To: <20080904193606.573f2cb3.sfr@canb.auug.org.au>
References: <20080904193606.573f2cb3.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

CONFIG_SND_USB_US122L uses snd_hwdep_new(), so SND_HWDEP needs
to be enabled (selected).

ERROR: "snd_hwdep_new" [sound/usb/usx2y/snd-usb-us122l.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 sound/usb/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20080904.orig/sound/usb/Kconfig
+++ linux-next-20080904/sound/usb/Kconfig
@@ -70,6 +70,7 @@ config SND_USB_CAIAQ_INPUT
 config SND_USB_US122L
 	tristate "Tascam US-122L USB driver"
 	depends on X86 && EXPERIMENTAL
+	select SND_HWDEP
 	select SND_RAWMIDI
 	help
 	  Say Y here to include support for Tascam US-122L USB Audio/MIDI
