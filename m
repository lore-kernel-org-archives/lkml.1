Return-Path: <linux-kernel-owner+w=401wt.eu-S934570AbZJNPlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934570AbZJNPlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934560AbZJNPlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:41:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:51790 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934558AbZJNPlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:41:44 -0400
Date: Wed, 14 Oct 2009 15:40:33 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, tglx@linutronix.de, gorcunov@gmail.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, tglx@linutronix.de, gorcunov@gmail.com,
       mingo@elte.hu
In-Reply-To: <20091014150904.GA5259@lenovo>
References: <20091014150904.GA5259@lenovo>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, apic: Explain show_lapic= in kernel parameters list
Message-ID: <tip-9636bc0555e3f383c120ddcffe4b7c5c58a10b1a@git.kernel.org>
Git-Commit-ID: 9636bc0555e3f383c120ddcffe4b7c5c58a10b1a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 15:40:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9636bc0555e3f383c120ddcffe4b7c5c58a10b1a
Gitweb:     http://git.kernel.org/tip/9636bc0555e3f383c120ddcffe4b7c5c58a10b1a
Author:     Cyrill Gorcunov <gorcunov@gmail.com>
AuthorDate: Wed, 14 Oct 2009 19:09:04 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 14 Oct 2009 17:28:05 +0200

x86, apic: Explain show_lapic= in kernel parameters list

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: yinghai@kernel.org
Cc: macro@linux-mips.org
LKML-Reference: <20091014150904.GA5259@lenovo>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/kernel-parameters.txt |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 9107b38..465a786 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -345,6 +345,15 @@ and is between 256 and 4096 characters. It is defined in the file
 			Change the amount of debugging information output
 			when initialising the APIC and IO-APIC components.
 
+	show_lapic=	[APIC,X86] Advanced Programmable Interrupt Controller
+			Limit apic dumping. The parameter defines the maximal
+			number of local apics being dumped. Also it is possible
+			to set it to "all" by meaning -- no limit here.
+			Format: { 1 (default) | 2 | ... | all }.
+			The parameter valid if only apic=debug or
+			apic=verbose is specified.
+			Example: apic=debug show_lapic=all
+
 	apm=		[APM] Advanced Power Management
 			See header of arch/x86/kernel/apm_32.c.
 
