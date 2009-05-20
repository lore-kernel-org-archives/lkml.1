Return-Path: <linux-kernel-owner+w=401wt.eu-S1756087AbZETPcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbZETPcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 11:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755483AbZETPcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 11:32:16 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:54412 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110AbZETPcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 11:32:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=I9oX7DWb4CPEpoTLoFJ2EwCxyNfqEKRWEp3UzPxhZsAtkBeL6YA4W1yj4EH4YtHSI6
         HJ3aRCVKm2G2+xrsoDS8KN5wIlNkOdPytBjh7DMcGTnEaDcoKwYtxAXh5TrH7O11Sb6l
         Xp5Ug8G7o7SzD7DZ+F+gEhZ0sXwb4uCq+gxx0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/4] hpt366: sync quirk_drives[] list with pdc202xx_{new,old}.c
Date: Wed, 20 May 2009 17:33:12 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-next-20090518-05332-g0707b5a; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Sergei Shtylyov <sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200905201733.12664.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
against Linus' tree

 drivers/ide/hpt366.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: b/drivers/ide/hpt366.c
===================================================================
--- a/drivers/ide/hpt366.c
+++ b/drivers/ide/hpt366.c
@@ -141,6 +141,10 @@
 static const char *quirk_drives[] = {
 	"QUANTUM FIREBALLlct08 08",
 	"QUANTUM FIREBALLP KA6.4",
+	"QUANTUM FIREBALLP KA9.1",
+	"QUANTUM FIREBALLP KX13.6",
+	"QUANTUM FIREBALLP KX20.5",
+	"QUANTUM FIREBALLP KX27.3",
 	"QUANTUM FIREBALLP LM20.4",
 	"QUANTUM FIREBALLP LM20.5",
 	NULL
