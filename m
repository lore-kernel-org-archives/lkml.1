Return-Path: <linux-kernel-owner+w=401wt.eu-S1754943AbYCMNZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943AbYCMNZu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 09:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbYCMNZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 09:25:42 -0400
Received: from styx.suse.cz ([82.119.242.94]:55828 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752216AbYCMNZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 09:25:42 -0400
Date: Thu, 13 Mar 2008 14:25:41 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Input: document i8042.noloop
Message-ID: <Pine.LNX.4.64.0803131423370.30831@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document 'noloop' kernel parameter of i8042 controller driver. Pointed out 
in #10236.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

--- 
 Documentation/kernel-parameters.txt |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 533e67f..09118a0 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -735,6 +735,8 @@ and is between 256 and 4096 characters. It is defined in the file
 			     (Don't attempt to blink the leds)
 	i8042.noaux	[HW] Don't check for auxiliary (== mouse) port
 	i8042.nokbd	[HW] Don't check/create keyboard port
+	i8042.noloop	[HW] Disable the AUX Loopback command while probing
+			     for the AUX port
 	i8042.nomux	[HW] Don't check presence of an active multiplexing
 			     controller
 	i8042.nopnp	[HW] Don't use ACPIPnP / PnPBIOS to discover KBD/AUX
