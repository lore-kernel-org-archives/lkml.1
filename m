Return-Path: <linux-kernel-owner+w=401wt.eu-S1758232AbZKDV0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758232AbZKDV0K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 16:26:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758176AbZKDV0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 16:26:07 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:61407 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758190AbZKDV0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 16:26:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=UlttLfW7hK5PH937yQ30vL6T3eZYDc+2KcrPNauWEfoXU1d6RDGTEpwRRQhU9yAMwT
         QsMEbJNxzGd5M+/sXqUo5rAYIVv1ICg6HX4iTUuqJo3eMUOpUUfTPi9MDQ0z3Lg8VLBn
         wc8tFFYW0It7Z3IFPK4nlKWEraVQyDQNMxftY=
From: Paul Fertser <fercerpav@gmail.com>
To: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, Lars-Peter Clausen <lars@metafoo.de>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Paul Fertser <fercerpav@gmail.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 3/6] gta02: set pcf50633 charger_reference_current_ma
Date: Thu,  5 Nov 2009 00:24:56 +0300
Message-Id: <1257369899-325-3-git-send-email-fercerpav@gmail.com>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1257369899-325-2-git-send-email-fercerpav@gmail.com>
References: <1257369899-325-1-git-send-email-fercerpav@gmail.com>
 <1257369899-325-2-git-send-email-fercerpav@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>

This value is board-specific and is needed for calculations to set charging
current limit properly.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Nelson Castillo <arhuaco@freaks-unidos.net>
Signed-off-by: Paul Fertser <fercerpav@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
---

Since this patch compile-depends on previous probably it should go through
the same tree as others. Nelson (gta02 maintainer) agrees with whatever you
think is best.

Anton Vorontsov is ok with merging it through his tree but needs an explicit
ack.

 arch/arm/mach-s3c2442/mach-gta02.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s3c2442/mach-gta02.c b/arch/arm/mach-s3c2442/mach-gta02.c
index 0fb385b..b0a3d74 100644
--- a/arch/arm/mach-s3c2442/mach-gta02.c
+++ b/arch/arm/mach-s3c2442/mach-gta02.c
@@ -268,6 +268,9 @@ struct pcf50633_platform_data gta02_pcf_pdata = {
 
 	.batteries = gta02_batteries,
 	.num_batteries = ARRAY_SIZE(gta02_batteries),
+
+	.charger_reference_current_ma = 1000,
+
 	.reg_init_data = {
 		[PCF50633_REGULATOR_AUTO] = {
 			.constraints = {
-- 
1.6.4.4

