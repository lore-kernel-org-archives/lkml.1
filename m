Return-Path: <linux-kernel-owner+w=401wt.eu-S1757755AbZDGOmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755AbZDGOmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 10:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757547AbZDGOmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 10:42:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43322 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757455AbZDGOmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 10:42:16 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 04/11] lanana: assign a device name and numbering for MAX3100
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Tue, 07 Apr 2009 16:41:00 +0100
Message-ID: <20090407154053.17182.72248.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090407153824.17182.81672.stgit@t61.ukuu.org.uk>
References: <20090407153824.17182.81672.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a low density serial port so needs a real major/minor

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 Documentation/devices.txt |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)


diff --git a/Documentation/devices.txt b/Documentation/devices.txt
index 4d70df6..53d64d3 100644
--- a/Documentation/devices.txt
+++ b/Documentation/devices.txt
@@ -2797,6 +2797,10 @@ Your cooperation is appreciated.
 		 206 = /dev/ttySC1		SC26xx serial port 1
 		 207 = /dev/ttySC2		SC26xx serial port 2
 		 208 = /dev/ttySC3		SC26xx serial port 3
+		 209 = /dev/ttyMAX0		MAX3100 serial port 0
+		 210 = /dev/ttyMAX1		MAX3100 serial port 1
+		 211 = /dev/ttyMAX2		MAX3100 serial port 2
+		 212 = /dev/ttyMAX3		MAX3100 serial port 3
 
 205 char	Low-density serial ports (alternate device)
 		  0 = /dev/culu0		Callout device for ttyLU0

