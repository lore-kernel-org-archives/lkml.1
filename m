Return-Path: <linux-kernel-owner+w=401wt.eu-S1755136AbYLIVUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbYLIVUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 16:20:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbYLIVUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 16:20:36 -0500
Received: from mail-ew0-f31.google.com ([209.85.219.31]:41737 "EHLO
	mail-ew0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbYLIVUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 16:20:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=AHpqv2Ht8nyyFLe/Ckr6K0iWmdHDJ0ZXXGZOZZTs9lMuAInI88QJudl6Kj1IoG6afF
         LvjNoCZPHATLgfz3oQlmw5UrCKcePFfq6cPtNfGJigmp3Q3fvBMbvK8a1sYA21nkMFVH
         6YeUf9146O/BojKgCxw/j6/zy7acnVNFahCwY=
Message-ID: <493EE11D.2000201@gmail.com>
Date: Tue, 09 Dec 2008 22:20:29 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: abelay@mit.edu, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 20/31] drivers/pnp: Make static
References: <493EA286.7080500@gmail.com>
In-Reply-To: <493EA286.7080500@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse asked whether these could be static.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/pnp/resource.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pnp/resource.c b/drivers/pnp/resource.c
index f604061..d5b1e05 100644
--- a/drivers/pnp/resource.c
+++ b/drivers/pnp/resource.c
@@ -30,8 +30,8 @@ static int pnp_reserve_mem[16] = {[0 ... 15] = -1 };	/* reserve (don't use) some
  * option registration
  */
 
-struct pnp_option *pnp_build_option(struct pnp_dev *dev, unsigned long type,
-				    unsigned int option_flags)
+static struct pnp_option *pnp_build_option(struct pnp_dev *dev,
+		unsigned long type, unsigned int option_flags)
 {
 	struct pnp_option *option;
 

