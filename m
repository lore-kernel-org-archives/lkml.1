Return-Path: <linux-kernel-owner+w=401wt.eu-S1756810AbZETPc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810AbZETPc5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 11:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755649AbZETPcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 11:32:18 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:51711 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbZETPcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 11:32:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=ZYDdWIhCJlVE/3ZxzRB9liEHQj59FsqvSfYhOqPypxrFnT7UUk8YG/65NQfSx8vWyY
         kW244z9qKZTru76HWxbv/ETdkZPPVSsceRY6NpH1kO8h+f5JjTeWma3tnMzGw1qfE22m
         kHYVAHl4MzBjX0k+rHVnXXxd3hFqmcx2gYpT0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/4] hpt366: enable all quirks for devices on quirk_drives[] list
Date: Wed, 20 May 2009 17:33:58 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-next-20090518-05332-g0707b5a; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Sergei Shtylyov <sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905201733.58869.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable also quirks in do_reset1() and ide_config_drive_speed()
for devices on quirk_drives[] list.

Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/hpt366.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/hpt366.c
===================================================================
--- a/drivers/ide/hpt366.c
+++ b/drivers/ide/hpt366.c
@@ -740,7 +740,7 @@ static void hpt3xx_quirkproc(ide_drive_t
 
 	while (*list)
 		if (strstr(m, *list++)) {
-			drive->quirk_list = 1;
+			drive->quirk_list = 2;
 			return;
 		}
 
