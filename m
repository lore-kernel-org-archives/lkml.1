Return-Path: <linux-kernel-owner+w=401wt.eu-S1753927AbYLAVAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbYLAVAc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 16:00:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbYLAVAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 16:00:24 -0500
Received: from eta-ori.net ([91.121.142.51]:51774 "EHLO orion.eta-ori.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbYLAVAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 16:00:24 -0500
Message-ID: <49345076.801@impulze.org>
Date: Mon, 01 Dec 2008 22:00:38 +0100
From: Daniel Mierswa <impulze@impulze.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081026)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-input@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Fujitsu Amilo PA 1510 key-release events quirk (PATCH
 2/3)
References: <4931BB48.9010706@impulze.org> <20081129233826.be959cae.akpm@linux-foundation.org>
In-Reply-To: <20081129233826.be959cae.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------080105000709000300080805"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080105000709000300080805
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Split patches as requested in "[PATCH] Fujitsu Amilo PA 1510 key-release
events quirk"

On 30.11.2008 08:41, Andrew Morton wrote:
> It's best to make forced_release_keys static as well - there is no need
> to build this array on the stack at runtime
done.

-- 

Mierswa, Daniel

If you still don't like it, that's ok: that's why I'm boss. I simply 
know better than you do.
                --- Linus Torvalds, comp.os.linux.advocacy, 1996/07/22



--------------080105000709000300080805
Content-Type: text/plain;
 name="atkbd_static_arrays.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="atkbd_static_arrays.patch"

>From 3b4eeb11c3dc09005fdd10d3fb22fb2267fd0d39 Mon Sep 17 00:00:00 2001
From: Daniel Mierswa <impulze@impulze.org>
Date: Sun, 30 Nov 2008 13:14:45 +0100
Subject: [PATCH] make forced_release_keys static

---
 drivers/input/keyboard/atkbd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
index c239745..11ded7e 100644
--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -852,7 +852,7 @@ static void atkbd_gen_release_event(struct atkbd* atkbd, const unsigned int *key
  */
 static void atkbd_dell_laptop_keymap_fixup(struct atkbd *atkbd)
 {
-	const unsigned int forced_release_keys[] = {
+	static const unsigned int forced_release_keys[] = {
 		0x85, 0x86, 0x87, 0x88, 0x89, 0x8a, 0x8b, 0x8f, 0x93,
 	};
 
@@ -866,7 +866,7 @@ static void atkbd_dell_laptop_keymap_fixup(struct atkbd *atkbd)
  */
 static void atkbd_hp_keymap_fixup(struct atkbd *atkbd)
 {
-	const unsigned int forced_release_keys[] = {
+	static const unsigned int forced_release_keys[] = {
 		0x94,
 	};
 
-- 
1.6.0.4




--------------080105000709000300080805--
