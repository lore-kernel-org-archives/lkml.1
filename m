Return-Path: <linux-kernel-owner+w=401wt.eu-S1759346AbXJYFdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346AbXJYFdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 01:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754350AbXJYFdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 01:33:22 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:35528 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753411AbXJYFdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 01:33:21 -0400
X-Greylist: delayed 1527 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Oct 2007 01:33:17 EDT
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200710250507.l9P57Pwh003203@turbo.physics.adelaide.edu.au>
Subject: Re: [2.6 patch] fujitsu-laptop.c: make 2 functions static
To: bunk@kernel.org (Adrian Bunk)
Date: Thu, 25 Oct 2007 14:37:25 +0930 (CST)
Cc: jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       len.brown@intel.com (Len Brown), linux-kernel@vger.kernel.org
In-Reply-To: <20071024162316.GJ30533@stusta.de> from "Adrian Bunk" at Oct 24, 2007 06:23:16 PM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> acpi_fujitsu_{add,remove}() can become static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Looks fine.  Ack.

Signed-off-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>

jonathan

---
 drivers/misc/fujitsu-laptop.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

175c8b648a54b625037916a8f6e3851574141532 
diff --git a/drivers/misc/fujitsu-laptop.c b/drivers/misc/fujitsu-laptop.c
index d366a6c..d686ba7 100644
--- a/drivers/misc/fujitsu-laptop.c
+++ b/drivers/misc/fujitsu-laptop.c
@@ -198,7 +198,7 @@ static struct platform_driver fujitsupf_driver = {
 
 /* ACPI device */
 
-int acpi_fujitsu_add(struct acpi_device *device)
+static int acpi_fujitsu_add(struct acpi_device *device)
 {
 	int result = 0;
 	int state = 0;
@@ -229,7 +229,7 @@ int acpi_fujitsu_add(struct acpi_device *device)
 	return result;
 }
 
-int acpi_fujitsu_remove(struct acpi_device *device, int type)
+static int acpi_fujitsu_remove(struct acpi_device *device, int type)
 {
 	ACPI_FUNCTION_TRACE("acpi_fujitsu_remove");
 

