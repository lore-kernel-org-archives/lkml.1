Return-Path: <linux-kernel-owner+w=401wt.eu-S1755982AbYBIEgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982AbYBIEgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 23:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752604AbYBIEgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 23:36:09 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:37205 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbYBIEgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 23:36:06 -0500
Date: Fri, 8 Feb 2008 20:32:23 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: alan@lxorguk.ukuu.org.uk, akpm <akpm@linux-foundation.org>
Subject: [PATCH] docbook: drop z85230 library from kernel-api
Message-Id: <20080208203223.85a288a3.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
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

cc: Alan Cox <alan@lxorguk.ukuu.org.uk>

Drop z85230 support library info from kernel-api since it's duplicated
in the Z85230 book.

Alan, is this OK with you?
(This is one of several patches that I have my queue for reducing the
size of kernel-api.* .)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/kernel-api.tmpl |    5 -----
 1 file changed, 5 deletions(-)

--- linux-2.6.24-git19.orig/Documentation/DocBook/kernel-api.tmpl
+++ linux-2.6.24-git19/Documentation/DocBook/kernel-api.tmpl
@@ -449,11 +449,6 @@ X!Isound/sound_firmware.c
 !Edrivers/serial/8250.c
   </chapter>
 
-  <chapter id="z85230">
-     <title>Z85230 Support Library</title>
-!Edrivers/net/wan/z85230.c
-  </chapter>
-
   <chapter id="fbdev">
      <title>Frame Buffer Library</title>
 
