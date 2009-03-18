Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbZCRU7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbZCRU7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 16:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754193AbZCRU71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 16:59:27 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:64175 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbZCRU7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 16:59:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=gFf7I3Mr1Gp37Atq57gUJQftc0WsLlm6pwCb1sPD9jfP/vm+6s1IvinktZ0WCDMGPr
         5hRUo5dAEFXsmu1uo/ws1zBf60lLa5WoihVzXPApCJgXKi8gdJ/4EAidysfAkaZYd28W
         rNGP113tcThzeLe9rUYC0oCr2KEf52Yl1yRIE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] MAINTAINERS: move old ide-{floppy,tape} entries to CREDITS
Date: Wed, 18 Mar 2009 22:01:32 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc8-next-20090317; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org, Gadi Oxman <gadio@netvision.net.il>,
       Paul Bristow <paul@paulbristow.net>,
       Borislav Petkov <petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903182201.32668.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] MAINTAINERS: move old ide-{floppy,tape} entries to CREDITS

Ben Hutchings noticed that MAINTAINERS somehow still contain old
ide-{floppy,tape} entries.  Fix it by moving them to CREDITS (kudos
to Gadi and Paul for all the early hard work on ide-{floppy,tape}).

Cc: Gadi Oxman <gadio@netvision.net.il>
Cc: Paul Bristow <paul@paulbristow.net>
Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
Borislav, maybe it would make sense to rename IDE/ATAPI CDROM DRIVER
entry to IDE/ATAPI DRIVERS one nowadays (you're the one doing most of
ATAPI work anyway :)?

 CREDITS     |    9 +++++++++
 MAINTAINERS |   13 -------------
 2 files changed, 9 insertions(+), 13 deletions(-)

Index: b/CREDITS
===================================================================
--- a/CREDITS
+++ b/CREDITS
@@ -495,6 +495,11 @@ S: Kopmansg 2
 S: 411 13  Goteborg
 S: Sweden
 
+N: Paul Bristow
+E: paul@paulbristow.net
+W: http://paulbristow.net/linux/idefloppy.html
+D: Maintainer of IDE/ATAPI floppy driver
+
 N: Dominik Brodowski
 E: linux@brodo.de
 W: http://www.brodo.de/
@@ -2642,6 +2647,10 @@ S: C/ Mieses 20, 9-B
 S: Valladolid 47009
 S: Spain
 
+N: Gadi Oxman
+E: gadio@netvision.net.il
+D: Original author and maintainer of IDE/ATAPI floppy/tape drivers
+
 N: Greg Page
 E: gpage@sovereign.org
 D: IPX development and support
Index: b/MAINTAINERS
===================================================================
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2179,19 +2179,6 @@ M:	petkovbb@gmail.com
 L:	linux-ide@vger.kernel.org
 S:	Maintained
 
-IDE/ATAPI FLOPPY DRIVERS
-P:	Paul Bristow
-M:	Paul Bristow <paul@paulbristow.net>
-W:	http://paulbristow.net/linux/idefloppy.html
-L:	linux-kernel@vger.kernel.org
-S:	Maintained
-
-IDE/ATAPI TAPE DRIVERS
-P:	Gadi Oxman
-M:	Gadi Oxman <gadio@netvision.net.il>
-L:	linux-kernel@vger.kernel.org
-S:	Maintained
-
 IDLE-I7300
 P:	Andy Henroid
 M:	andrew.d.henroid@intel.com
