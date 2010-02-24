Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab0BXHiK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 02:38:10 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:39422 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476Ab0BXHiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 02:38:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=s2rYGuxgLw9wkfAxxoaluHjfrT7WUSD/p1egClw7FZ+4JuOmTrzjvKU3kdLgqfTMej
         clC64D5fKQDQfqIty4nYr5BusEapj2et6IQ07K6YlhfKf2G8tLIAzXwebM5RZxzk/E/O
         rT/v+GPMDYZUlBCilyP0FVXgIx2SqYLR/7cqk=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 04/14] Regulators: twl-regulator - mark probe function as
	__devinit
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 23 Feb 2010 23:38:01 -0800
Message-ID: <20100224073801.15964.32639.stgit@localhost.localdomain>
In-Reply-To: <20100224073342.15964.8863.stgit@localhost.localdomain>
References: <20100224073342.15964.8863.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/regulator/twl-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index 5f394bb..9729d76 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -531,7 +531,7 @@ static struct twlreg_info twl_regs[] = {
 	TWL6030_FIXED_LDO(VUSB, 0x70, 3300, 18, 0, 0x21)
 };
 
-static int twlreg_probe(struct platform_device *pdev)
+static int __devinit twlreg_probe(struct platform_device *pdev)
 {
 	int				i;
 	struct twlreg_info		*info;

