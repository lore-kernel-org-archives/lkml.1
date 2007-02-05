Return-Path: <linux-kernel-owner+w=401wt.eu-S1752451AbXBEJoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451AbXBEJoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 04:44:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbXBEJoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 04:44:32 -0500
Received: from outmail1.freedom2surf.net ([194.106.33.237]:50980 "EHLO
	outmail1.freedom2surf.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbXBEJob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 04:44:31 -0500
X-Greylist: delayed 1242 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Feb 2007 04:44:31 EST
Message-ID: <45C6F7BA.5050700@f2s.com>
Date: Mon, 05 Feb 2007 09:24:10 +0000
From: Ian Molton <spyro@f2s.com>
Organization: The Dragon Roost
User-Agent: Thunderbird 2.0a1 (X11/20061107)
MIME-Version: 1.0
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: kernel@wantstofly.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.20] arch ARM: Use ARRAY_SIZE macro when appropriate
References: <20070205024357.GP18118@Ahmed>
In-Reply-To: <20070205024357.GP18118@Ahmed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ahmed S. Darwish wrote:
> Hi all,
> 
> A patch to use ARRAY_SIZE macro already defined in linux/kernel.h

Looks good. I can only speak for arm26 though, however trivial this is.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Acked-by: Ian Molton <spyro@f2s.com

> ---
> Patch isn't compile checked cause I have no ARM machine at hand.
> Thanks,


diff --git a/arch/arm/kernel/ecard.c b/arch/arm/kernel/ecard.c
index 71257e3..f1c0fb9 100644
--- a/arch/arm/kernel/ecard.c
+++ b/arch/arm/kernel/ecard.c
@@ -1009,7 +1009,7 @@ ecard_probe(int slot, card_type_t type)
  		ec->fiqmask = 4;
  	}

-	for (i = 0; i < sizeof(blacklist) / sizeof(*blacklist); i++)
+	for (i = 0; i < ARRAY_SIZE(blacklist); i++)
  		if (blacklist[i].manufacturer == ec->cid.manufacturer &&
  		    blacklist[i].product == ec->cid.product) {
  			ec->card_desc = blacklist[i].type;
diff --git a/arch/arm26/kernel/ecard.c b/arch/arm26/kernel/ecard.c
index 9dbc172..e2bcefc 100644
--- a/arch/arm26/kernel/ecard.c
+++ b/arch/arm26/kernel/ecard.c
@@ -665,7 +665,7 @@ ecard_probe(int slot, card_type_t type)
  		ec->fiqmask = 4;
  	}

-	for (i = 0; i < sizeof(blacklist) / sizeof(*blacklist); i++)
+	for (i = 0; i < ARRAY_SIZE(blacklist); i++)
  		if (blacklist[i].manufacturer == ec->cid.manufacturer &&
  		    blacklist[i].product == ec->cid.product) {
  			ec->card_desc = blacklist[i].type;


