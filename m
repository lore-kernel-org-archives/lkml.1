Return-Path: <linux-kernel-owner+w=401wt.eu-S1761665AbXESKAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761665AbXESKAg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 06:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756360AbXESKA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 06:00:29 -0400
Received: from n8.bullet.re3.yahoo.com ([68.142.237.93]:27065 "HELO
	n8.bullet.re3.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755548AbXESKA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 06:00:28 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 336194.68247.bm@rrr4.mail.re1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=EkE9kTlQDqaKwzXlYxkVGia6XTnPfL0oUq7ZkYbBK3uBavul3MZa2/ZkFwD0ouufGG6Tgqv/TRl/0kPQrGt6TL5Nx1x+XxZxLuLlSUA8b7b6UVaO8LFbvZIhpCcjyt7rqwHXjh9H23f27n2pdG8ugxFS6hD6QFtEOovkTW+MsLA=;
X-YMail-OSG: OntcOIwVM1l04RqmDkVB87J3cpPU5x_zpQa_lVeCrrej0atW6AlDf8HSBlOI1zs2siw0r68VGpyOvYgcJk5og8AQT6VKt.B1UE9kM6JHNTD7NBxcpz5xPmtk581MmuM4
Date: Sat, 19 May 2007 03:00:27 -0700 (PDT)
From: Tear <tarrqt@yahoo.com>
Subject: [patch] Dell Optiplex GX240, ACPI and APIC
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <20070512103441.a21194fc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <147799.82847.qm@web63612.mail.re1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch removes Dell Optiplex GX240 from
the ACPI blacklist.

Please see the following for more information:

http://marc.info/?l=linux-kernel&m=117897875024464&w=2

Regards,
- Tear

--- linux-2.6.21.1.orig/arch/i386/kernel/acpi/boot.c	2007-05-01 17:10:30.000000000 +0300
+++ linux-2.6.21.1/arch/i386/kernel/acpi/boot.c	2007-05-01 20:31:53.000000000 +0300
@@ -971,14 +971,6 @@
 	 },
 	{
 	 .callback = force_acpi_ht,
-	 .ident = "DELL GX240",
-	 .matches = {
-		     DMI_MATCH(DMI_BOARD_VENDOR, "Dell Computer Corporation"),
-		     DMI_MATCH(DMI_BOARD_NAME, "OptiPlex GX240"),
-		     },
-	 },
-	{
-	 .callback = force_acpi_ht,
 	 .ident = "HP VISUALIZE NT Workstation",
 	 .matches = {
 		     DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),





       
____________________________________________________________________________________Get the Yahoo! toolbar and be alerted to new email wherever you're surfing.
http://new.toolbar.yahoo.com/toolbar/features/mail/index.php

