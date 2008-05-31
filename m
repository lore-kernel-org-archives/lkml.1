Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945AbYEaAnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbYEaAnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 20:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbYEaAnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 20:43:12 -0400
Received: from fmmailgate05.web.de ([217.72.192.243]:51392 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbYEaAnL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 20:43:11 -0400
Date: Sat, 31 May 2008 02:43:09 +0200
Message-Id: <298760125@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@redhat.com>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH] fix Kconfig after ip2/ip2main merge
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1+o2vhEi2RRMQLtZl2TkpV7KomVnzWi3rda2i4xothSVhvBb
 4JsgD+4Igozi7a8PvbJuPT61gB20QxxrOl79oA1i0TxLZShiAA=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

as commit  6089093e588ee3f6aed99d08b1cf5ea37c52cf97  is fixing ip2 crashes on 
load/unload and making ip2/ip2main one module (ip2),  Kconfig shouldn`t mention
non existing module. I seldom posting patches and only have webmailer here, so 
please indulge if there is something wrong with formatting or style.

Signed-off-by: Roland.Kletzing <devzero@web.de>
---
 drivers/char/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

===================================================================
--- a/drivers/char/Kconfig.orig     2008-05-31 02:14:42.000000000 +0200
+++ b/drivers/char/Kconfig  2008-05-31 02:15:15.000000000 +0200
@@ -118,8 +118,8 @@
          order to become a dial-in server. If you have a card like that, say
          Y here and read <file:Documentation/computone.txt>.

-         To compile this driver as modules, choose M here: the
-         modules will be called ip2 and ip2main.
+         To compile this driver as module, choose M here: the
+         module will be called ip2.

 config ROCKETPORT
        tristate "Comtrol RocketPort support"
_______________________________________________________________________
EINE FÜR ALLE: die kostenlose WEB.DE-Plattform für Freunde und Deine
Homepage mit eigenem Namen. Jetzt starten! http://unddu.de/?kid=kid@mf2

