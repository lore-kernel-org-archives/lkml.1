Return-Path: <linux-kernel-owner+w=401wt.eu-S1754400Ab0ARQFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab0ARQFw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 11:05:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754245Ab0ARQFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 11:05:43 -0500
Received: from cantor.suse.de ([195.135.220.2]:36466 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142Ab0ARQFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 11:05:41 -0500
Date: Mon, 18 Jan 2010 17:05:40 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [PATCH] x86: put 'nopat' in kernel-parameters
Message-ID: <alpine.LNX.2.00.1001181703560.30977@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing 'nopat' boot option into Documentation/kernel-parameters.txt.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 Documentation/kernel-parameters.txt |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 736d456..5bf45c0 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1729,6 +1729,9 @@ and is between 256 and 4096 characters. It is defined in the file
 	nomfgpt		[X86-32] Disable Multi-Function General Purpose
 			Timer usage (for AMD Geode machines).
 
+	nopat		[X86] Disable PAT (page attribute table extension of
+			pagetables) support.
+
 	norandmaps	Don't use address space randomization.  Equivalent to
 			echo 0 > /proc/sys/kernel/randomize_va_space
 
-- 
1.6.4.2

