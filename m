Return-Path: <linux-kernel-owner+w=401wt.eu-S1755829AbYCJXex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829AbYCJXex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 19:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbYCJXeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 19:34:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:14345 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbYCJXeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 19:34:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=cGqgDWn0FT0RERFaTn5Y3zH0XnfboE6OkApHT3onCIdlctxq37zYkE30ihHFQhjZmIcYshLXIdTJJ0945rR/Fl2KsmW7NZ91QZGGPa/7qLiGWmwSGLAIF3OvScTphwVtV+fKfkHlBiNrQiynx9deudfaylHzkCxKKDlCzhv3ybs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/5] ide: remove commented out entries from ide_pio_blacklist[]
Date: Tue, 11 Mar 2008 00:46:23 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803110046.23245.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-lib.c |   10 ----------
 1 file changed, 10 deletions(-)

Index: b/drivers/ide/ide-lib.c
===================================================================
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -122,7 +122,6 @@ static struct ide_pio_info {
 	const char	*name;
 	int		pio;
 } ide_pio_blacklist [] = {
-/*	{ "Conner Peripherals 1275MB - CFS1275A", 4 }, */
 	{ "Conner Peripherals 540MB - CFS540A", 3 },
 
 	{ "WDC AC2700",  3 },
@@ -138,10 +137,8 @@ static struct ide_pio_info {
 	{ "WDC AC1170",  1 },
 	{ "WDC AC1210",  1 },
 	{ "WDC AC280",   0 },
-/*	{ "WDC AC21000", 4 }, */
 	{ "WDC AC31000", 3 },
 	{ "WDC AC31200", 3 },
-/*	{ "WDC AC31600", 4 }, */
 
 	{ "Maxtor 7131 AT", 1 },
 	{ "Maxtor 7171 AT", 1 },
@@ -155,13 +152,6 @@ static struct ide_pio_info {
 	{ "SAMSUNG SHD-3122A", 1 },
 	{ "SAMSUNG SHD-3172A", 1 },
 
-/*	{ "ST51080A", 4 },
- *	{ "ST51270A", 4 },
- *	{ "ST31220A", 4 },
- *	{ "ST31640A", 4 },
- *	{ "ST32140A", 4 },
- *	{ "ST3780A",  4 },
- */
 	{ "ST5660A",  3 },
 	{ "ST3660A",  3 },
 	{ "ST3630A",  3 },
