Return-Path: <linux-kernel-owner+w=401wt.eu-S1752872Ab0ATQxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab0ATQxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 11:53:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751082Ab0ATQxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 11:53:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:53640 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752706Ab0ATQxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 11:53:12 -0500
Date: Wed, 20 Jan 2010 16:52:39 GMT
From: tip-bot for Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jkosina@suse.cz, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, jkosina@suse.cz, mingo@elte.hu
In-Reply-To: <alpine.LNX.2.00.1001181703560.30977@pobox.suse.cz>
References: <alpine.LNX.2.00.1001181703560.30977@pobox.suse.cz>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/doc] x86: Put 'nopat' in kernel-parameters
Message-ID: <tip-016ddd9b5b315fe52ac6ba3167521f50b3868d34@git.kernel.org>
Git-Commit-ID: 016ddd9b5b315fe52ac6ba3167521f50b3868d34
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 20 Jan 2010 16:52:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  016ddd9b5b315fe52ac6ba3167521f50b3868d34
Gitweb:     http://git.kernel.org/tip/016ddd9b5b315fe52ac6ba3167521f50b3868d34
Author:     Jiri Kosina <jkosina@suse.cz>
AuthorDate: Mon, 18 Jan 2010 17:05:40 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 20 Jan 2010 08:58:04 +0100

x86: Put 'nopat' in kernel-parameters

Add missing 'nopat' boot option into
Documentation/kernel-parameters.txt.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
LKML-Reference: <alpine.LNX.2.00.1001181703560.30977@pobox.suse.cz>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
 
