Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbYLORmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbYLORmr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 12:42:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754696AbYLORmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 12:42:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:42018 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbYLORmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 12:42:39 -0500
Subject: [PATCH] x86: setup.c find_and_reserve_crashkernel should be static
From: Jaswinder Singh <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 15 Dec 2008 23:11:10 +0530
Message-Id: <1229362870.15326.13.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
---
 arch/x86/kernel/setup.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index c222a8f..14b7d54 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -450,6 +450,7 @@ static void __init reserve_early_setup_data(void)
  * @size: Size of the crashkernel memory to reserve.
  * Returns the base address on success, and -1ULL on failure.
  */
+static
 unsigned long long __init find_and_reserve_crashkernel(unsigned long long size)
 {
 	const unsigned long long alignment = 16<<20; 	/* 16M */
-- 
1.5.5.1



