Return-Path: <linux-kernel-owner+w=401wt.eu-S1753703AbZECBKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703AbZECBKF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 21:10:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753088AbZECBJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 21:09:54 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:17074 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbZECBJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 21:09:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=fn6XGfTwjgk3WIR+T44Cfx3g9gzxjxR2MFDV9sFkgWDOMHkL5ICm7xhV+vVNhmEQwy
         UnHLipinXbm0a7d+Q+cMPPU83NImxvyvv/PkgFuqxA+yCGjd1IBy6SfVqeJ02MSasjfT
         j2viLtg8UF+GjemMNuor95iiq5SZwTWY93cj4=
MIME-Version: 1.0
Date: Sun, 3 May 2009 10:09:54 +0900
Message-ID: <3ecd1e960905021809p448f6b0eo3a530cd35d4f763e@mail.gmail.com>
Subject: [PATCH] gfp.h: a trivial comment typo
From: Kazuo Ito <kzpn200@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

It's really trivial and doesn't mean much for overall code
quality, but since I found it...

commit 99b4ac1ebc20382c2215ae984d565ab183e0f4bc
Author: Kazuo Ito <kzpn200@gmail.com>
Date:   Sun May 3 09:56:35 2009 +0900

    gfp.h: a comment typo
---
 include/linux/gfp.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 0bbc15f..eda48ed 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -14,7 +14,7 @@ struct vm_area_struct;
  * Zone modifiers (see linux/mmzone.h - low three bits)
  *
  * Do not put any conditional on these. If necessary modify the definitions
- * without the underscores and use the consistently. The definitions here may
+ * without the underscores and use them consistently. The definitions here may
  * be used in bit comparisons.
  */
 #define __GFP_DMA	((__force gfp_t)0x01u)
