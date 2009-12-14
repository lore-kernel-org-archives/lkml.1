Return-Path: <linux-kernel-owner+w=401wt.eu-S1756433AbZLNCHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433AbZLNCHr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 21:07:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756420AbZLNCHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 21:07:47 -0500
Received: from sh.osrg.net ([192.16.179.4]:57350 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756414AbZLNCHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 21:07:46 -0500
Date: Mon, 14 Dec 2009 11:06:15 +0900
To: mingo@elte.hu
Cc: gcosta@redhat.com, amwang@redhat.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] remove usedac in feature-removal-schedule.txt
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091214104423X.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 14 Dec 2009 11:06:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reason of removal, "replaced by allowdac and no dac combination"
is incorrect. There is no way to do the same thing with "allowdac" and
"nodac" combination.

The usedac option enables us to stop via_no_dac() setting forbid_dac
to 1. That is, someone who uses VIA bridges can use DAC with this
option even if some of VIA bridges seem to be broken about DAC.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 Documentation/feature-removal-schedule.txt |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 2a4d779..eb2c138 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -291,13 +291,6 @@ Who:	Michael Buesch <mb@bu3sch.de>
 
 ---------------------------
 
-What:	usedac i386 kernel parameter
-When:	2.6.27
-Why:	replaced by allowdac and no dac combination
-Who:	Glauber Costa <gcosta@redhat.com>
-
----------------------------
-
 What: print_fn_descriptor_symbol()
 When: October 2009
 Why:  The %pF vsprintf format provides the same functionality in a
-- 
1.5.6.5

