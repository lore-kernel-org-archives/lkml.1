Return-Path: <linux-kernel-owner+w=401wt.eu-S1760092AbXHXOgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760092AbXHXOgz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 10:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbXHXOgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 10:36:46 -0400
Received: from 85-18-251-172.ip.fastwebnet.it ([85.18.251.172]:56127 "EHLO
	memento.home.lan" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752408AbXHXOgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 10:36:45 -0400
From: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>
Subject: [PATCH] usbmon doc update - mention new wildcard ('0') bus
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Pete Zaitcev <zaitcev@redhat.com>,
       Alan Stern <stern@rowland.harvard.edu>
Date: Fri, 24 Aug 2007 12:19:22 +0200
Message-ID: <20070824101922.17474.80671.stgit@americanbeauty.home.lan>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Update usbmon documentation, mentioning the "zero" (wildcard) bus.
Possibly, in my first hunk, the 'either ... or ...' should be rephrased a bit to
be expressed better.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>
Cc: Pete Zaitcev <zaitcev@redhat.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
---

 Documentation/usb/usbmon.txt |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/Documentation/usb/usbmon.txt b/Documentation/usb/usbmon.txt
index 53ae866..2917ce4 100644
--- a/Documentation/usb/usbmon.txt
+++ b/Documentation/usb/usbmon.txt
@@ -34,9 +34,12 @@ if usbmon is built into the kernel.
 Verify that bus sockets are present.
 
 # ls /sys/kernel/debug/usbmon
-1s  1t  1u  2s  2t  2u  3s  3t  3u  4s  4t  4u
+0s  0t  0u  1s  1t  1u  2s  2t  2u  3s  3t  3u  4s  4t  4u
 #
 
+Now you can choose to either use the sockets numbered '0' (to capture packets on
+all buses), and skip to step #3, or find the bus used by your device with step #2.
+
 2. Find which bus connects to the desired device
 
 Run "cat /proc/bus/usb/devices", and find the T-line which corresponds to
@@ -56,6 +59,10 @@ Bus=03 means it's bus 3.
 
 # cat /sys/kernel/debug/usbmon/3u > /tmp/1.mon.out
 
+to listen on a single bus, otherwise, to listen on all buses, type:
+
+# cat /sys/kernel/debug/usbmon/0u > /tmp/1.mon.out
+
 This process will be reading until killed. Naturally, the output can be
 redirected to a desirable location. This is preferred, because it is going
 to be quite long.

