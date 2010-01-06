Return-Path: <linux-kernel-owner+w=401wt.eu-S932386Ab0AFWUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386Ab0AFWUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 17:20:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932311Ab0AFWUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 17:20:49 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:54507 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932273Ab0AFWUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 17:20:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=uGHyChr6JapiJ/FTiFhClS1NGA9J60Va5I+uKuZp6p5Ua9Ai95vdtRk/opHdrhTCCO
         1oYpomdbwrnntXO11jIx2neYv/6z4iwv/HzcMjogXVZUZFBYQ1RvrvPZpUiKNqexyfj4
         7APR++PN6bm98O8526qsVh5gfVOnqQ0Z/GajQ=
Message-ID: <4B450DA3.5010305@gmail.com>
Date: Wed, 06 Jan 2010 23:24:35 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Ben Dooks <ben-linux@fluff.org>, linux-arm-kernel@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ARM: add missing parentheses
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`!' has a higher precedence than `&' so parentheses are required.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 arch/arm/mach-s3c2440/mach-osiris-dvs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-s3c2440/mach-osiris-dvs.c b/arch/arm/mach-s3c2440/mach-osiris-dvs.c
index ad2792d..0abcd38 100644
--- a/arch/arm/mach-s3c2440/mach-osiris-dvs.c
+++ b/arch/arm/mach-s3c2440/mach-osiris-dvs.c
@@ -77,8 +77,8 @@ static int osiris_dvs_notify(struct notifier_block *nb,
 		}
 		break;
 	case CPUFREQ_POSTCHANGE:
-		if (!old_dvs & new_dvs ||
-		    !cur_dvs & new_dvs) {
+		if (!(old_dvs & new_dvs) ||
+		    !(cur_dvs & new_dvs)) {
 			pr_debug("entering dvs\n");
 			cur_dvs = true;
 			gpio_set_value(OSIRIS_GPIO_DVS, 0);
