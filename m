Return-Path: <linux-kernel-owner+w=401wt.eu-S1754587AbYLIRwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbYLIRwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 12:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbYLIRwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 12:52:06 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:34965 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbYLIRwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 12:52:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=fR47bY1Wjxl7ZtgxJcgCIkfIzjr9Cdjd3iGI80bB23FmxAWsRd5SXUiwaGhvt3Cv7f
         ib9/N8a430AqFBBFSC0tyhTyW4rh7HUzcJ1cnKGvb5jzKP0Gy3hgLweQYs9QNPypw3kM
         m9QjmNujLxQ+mCFTZCGbpkGXhBenVyT7cblYg=
Message-ID: <493EB040.4090206@gmail.com>
Date: Tue, 09 Dec 2008 18:52:00 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/33] drivers/dca: Make static
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
 drivers/dca/dca-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dca/dca-core.c b/drivers/dca/dca-core.c
index d883e1b..3e5d947 100644
--- a/drivers/dca/dca-core.c
+++ b/drivers/dca/dca-core.c
@@ -131,7 +131,7 @@ EXPORT_SYMBOL_GPL(dca_remove_requester);
  * @dev - the device that wants dca service
  * @cpu - the cpuid as returned by get_cpu()
  */
-u8 dca_common_get_tag(struct device *dev, int cpu)
+static u8 dca_common_get_tag(struct device *dev, int cpu)
 {
 	struct dca_provider *dca;
 	u8 tag;
