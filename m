Return-Path: <linux-kernel-owner+w=401wt.eu-S1761329AbYBBGhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761329AbYBBGhG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 01:37:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754248AbYBBGgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 01:36:55 -0500
Received: from an-out-0708.google.com ([209.85.132.242]:19358 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbYBBGgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 01:36:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=PYNt3X8NUSbJTKelxD8eYg0hnzZeZPR/UtKnDaJeafuaWvPRgg6T0BxuwyIN+wGcwsTaxwb5Y2s9mony5G0MQT09J60p0sPTZ01JP7wTTYIaVShq6fxKE1ed/jDfqCK9cxSuptzZ69PW8IWlQUHkAaaotjM301acetZFAUJL2Xc=
Message-ID: <28c262360802012236w3a1b4253h2a6ad96570d4a634@mail.gmail.com>
Date: Sat, 2 Feb 2008 15:36:54 +0900
From: "minchan kim" <minchan.kim@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       "Andy Whitcroft" <apw@shadowen.org>
Subject: [PATCH] modify incorrected word in comment of clear_active_flags
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think is was a mistake.
clear_active_flags is just called by shrink_inactive_list.

--- mm/vmscan.c.orig  2008-02-02 15:21:52.000000000 +0900
+++ mm/vmscan.c 2008-02-02 15:20:46.000000000 +0900
@@ -761,7 +761,7 @@ static unsigned long isolate_lru_pages(u
 }

 /*
- * clear_active_flags() is a helper for shrink_active_list(), clearing
+ * clear_active_flags() is a helper for shrink_inactive_list(), clearing
  * any active bits from the pages in the list.
  */
 static unsigned long clear_active_flags(struct list_head *page_list)



-- 
Kinds regards,
barrios
