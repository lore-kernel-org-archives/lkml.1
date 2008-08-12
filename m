Return-Path: <linux-kernel-owner+w=401wt.eu-S1753053AbYHLUkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053AbYHLUkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 16:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbYHLUkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 16:40:14 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:49901 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbYHLUkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 16:40:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=XpPIUefVYmPwyPmnr18SlMdSyYTUQiLKM7W3foc2x5uRtDyB8cSODAmfnWmUb7wPQ8
         RvOoTJlW54NDoRJN3QXe9lhT8ChwwQISWtJ6OLL2QevhOg1gKm87DKsX5o0Yt2GpJW2C
         wPHH3zXOyC/xUgIMJZds6sQhvACAJk6OD2j3E=
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: [PATCH] Make gpiochip label const
Date: Wed, 13 Aug 2008 00:39:48 +0400
Message-Id: <1218573588-25528-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark gpiochip label as a const char pointer.

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
---
 include/asm-generic/gpio.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 6be061d..8ab874a 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -58,7 +58,7 @@ struct module;
  * is calculated by subtracting @base from the gpio number.
  */
 struct gpio_chip {
-	char			*label;
+	const char		*label;
 	struct module		*owner;
 
 	int			(*direction_input)(struct gpio_chip *chip,
-- 
1.5.6.3

