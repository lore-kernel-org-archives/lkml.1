Return-Path: <linux-kernel-owner+w=401wt.eu-S1754472AbXLHUmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbXLHUmA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 15:42:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbXLHUlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 15:41:53 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:36190 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbXLHUlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 15:41:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:content-transfer-encoding:user-agent;
        b=cm71eYylbGo5Kjtx06dPqHC6fsBWMfuuO1d//iTXS/IF65tEjpJeR6vRAK6cVJvj5DGri7Dy8EJ3Pdnq5Ogi63tHl0EG0jfABhTGsszODb9rR7pLa2LAE3pzXqnQkIHmsv59ej6ab3kz9bGBzcJavIL2eBu3BAapTOZl1GsybBE=
Date: Sat, 8 Dec 2007 21:42:55 +0100
From: Marcin =?utf-8?Q?=C5=9Alusarz?= <marcin.slusarz@gmail.com>
To: perex@perex.cz
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] pcm_lib: fix sparse warning about different signedness
Message-ID: <20071208204252.GD5087@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pcm_lib: fix sparse warning about different signedness

Signed-off-by: Marcin Ślusarz <marcin.slusarz@gmail.com>
---
 sound/core/pcm_lib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index 653fb5c..f2c3cf3 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1139,7 +1139,7 @@ EXPORT_SYMBOL(snd_pcm_hw_constraint_step);

 static int snd_pcm_hw_rule_pow2(struct snd_pcm_hw_params *params, struct snd_pcm_hw_rule *rule)
 {
-	static int pow2_sizes[] = {
+	static unsigned int pow2_sizes[] = {
 		1<<0, 1<<1, 1<<2, 1<<3, 1<<4, 1<<5, 1<<6, 1<<7,
 		1<<8, 1<<9, 1<<10, 1<<11, 1<<12, 1<<13, 1<<14, 1<<15,
 		1<<16, 1<<17, 1<<18, 1<<19, 1<<20, 1<<21, 1<<22, 1<<23,
