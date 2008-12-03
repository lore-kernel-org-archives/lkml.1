Return-Path: <linux-kernel-owner+w=401wt.eu-S1753771AbYLCMio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbYLCMio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 07:38:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbYLCMid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 07:38:33 -0500
Received: from mercuryimc.plus.com ([80.229.200.144]:54789 "EHLO
	mimc.mimc.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752119AbYLCMic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 07:38:32 -0500
Message-ID: <49367DC8.1050708@mimc.co.uk>
Date: Wed, 03 Dec 2008 12:38:32 +0000
From: Mark Jackson <mpfj@mimc.co.uk>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: kernel@avr32linux.org, lkml <linux-kernel@vger.kernel.org>
CC: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH 1/1] MIMC200: Remove deprecated call
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes a call to the deprecated function at32_add_system_devices().

Signed-off-by: Mark Jackson <mpfj@mimc.co.uk>

---
  arch/avr32/boards/mimc200/setup.c |    2 --
  1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/avr32/boards/mimc200/setup.c b/arch/avr32/boards/mimc200/setup.c
index 397cbb8..c060d4d 100644
--- a/arch/avr32/boards/mimc200/setup.c
+++ b/arch/avr32/boards/mimc200/setup.c
@@ -207,8 +207,6 @@ static int __init mimc200_init(void)
  	 * reserve any pins for it.
  	 */

-	at32_add_system_devices();
-
  	at32_add_device_usart(0);
  	at32_add_device_usart(1);
  	at32_add_device_usart(2);
