Return-Path: <linux-kernel-owner+w=401wt.eu-S1756249AbYANLLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249AbYANLLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 06:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755100AbYANLLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 06:11:05 -0500
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:44912 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752236AbYANLLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 06:11:04 -0500
Date: Mon, 14 Jan 2008 12:10:57 +0100
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH for git-x86] Export native_read_tsc
Message-ID: <20080114111056.GA1659@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 14 Jan 2008 11:04:49.0355 (UTC) FILETIME=[47BE09B0:01C8569D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Otherwise modular tcrypt, kvm-intel have unresolved symbols.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/arch/x86/kernel/rtc.c
===================================================================
--- linux.orig/arch/x86/kernel/rtc.c
+++ linux/arch/x86/kernel/rtc.c
@@ -200,3 +200,5 @@ unsigned long long native_read_tsc(void)
 {
 	return __native_read_tsc();
 }
+EXPORT_SYMBOL(native_read_tsc);
+
