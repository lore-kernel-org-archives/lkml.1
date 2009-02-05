Return-Path: <linux-kernel-owner+w=401wt.eu-S1759482AbZBEQy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759482AbZBEQy4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 11:54:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758650AbZBEQyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 11:54:00 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:27469 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758564AbZBEQx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 11:53:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=cDh+qc2U/5X80PZae4j6j+WTLD+27qY4GmX2wgu+d5QJMvVUj8qZ/mevsFuUH6UbpW
         sG3qbir1BkGd6ZHbwmatqX18X0oYqbJgRhB0XZtFd0JIIEh7bg9+vQ5ahhsq0F9oUotj
         SaNB5xOzqP8efMBtZJ35Ueev/vPzcAiy41Qwk=
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@openedhand.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Matt Reimer <mreimer@vpop.net>,
       Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 3/6] pxa/magician: remove deprecated .bus_shift from PASIC3 platform_data
Date: Thu,  5 Feb 2009 17:53:37 +0100
Message-Id: <1233852820-28549-4-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1233852820-28549-1-git-send-email-philipp.zabel@gmail.com>
References: <1233852820-28549-1-git-send-email-philipp.zabel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PASIC3 driver now calculates its register spacing from the resource
size.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 arch/arm/mach-pxa/magician.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-pxa/magician.c b/arch/arm/mach-pxa/magician.c
index 21b821e..8e21181 100644
--- a/arch/arm/mach-pxa/magician.c
+++ b/arch/arm/mach-pxa/magician.c
@@ -495,7 +495,6 @@ static struct resource pasic3_resources[] = {
 };
 
 static struct pasic3_platform_data pasic3_platform_data = {
-	.bus_shift  = 2,
 	.led_pdata  = &pasic3_leds_info,
 	.clock_rate = 4000000,
 };
-- 
1.5.6.5

