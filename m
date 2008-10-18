Return-Path: <linux-kernel-owner+w=401wt.eu-S1751981AbYJRNnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbYJRNnf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 09:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbYJRNn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 09:43:28 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:49328 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbYJRNn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 09:43:27 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: fix potential build error in slicoss driver
Date: Sat, 18 Oct 2008 15:43:27 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810181543.28054.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	This hides under DEBUG_REGISTER_TRACE so probably
not visible to many people.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

index b61ac4b..47b0ae1 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -275,7 +275,6 @@ static void slic_dbg_register_trace(struct adapter *adapter,
 			  card->reg_value[i], card->reg_valueh[i]);
 	}
 }
-}
 #endif
