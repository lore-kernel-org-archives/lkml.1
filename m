Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbZGOS1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbZGOS1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 14:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755654AbZGOS13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 14:27:29 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:46390 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348AbZGOS12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 14:27:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=JA3EZgMAqWlYsvbDAwTW9WyZx8AcaRv2nnUTbRMtH4C8B0g8csYVYqhHOTGHIUH2MV
         c16pZdGFWuOUGF2lzuoYyfjkMT/p4XKI/YLmsT//Qqqi4abeCDOebZ4SFkG4z31twB49
         Zi6xn6m+pzzU+onDbgD/63Ofkf6R2X7CRCd80=
Message-ID: <4A5E1FF3.6010108@gmail.com>
Date: Wed, 15 Jul 2009 20:29:07 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: gnb@melbourne.sgi.com, jbaron@redhat.com, gregkh@suse.de,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Dynamic debug: fix typo: -/->
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The member was intended, not the local variable.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Right?

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 833139c..e22c148 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -164,7 +164,7 @@ static void ddebug_change(const struct ddebug_query *query,
 
 			if (!newflags)
 				dt->num_enabled--;
-			else if (!dp-flags)
+			else if (!dp->flags)
 				dt->num_enabled++;
 			dp->flags = newflags;
 			if (newflags) {
