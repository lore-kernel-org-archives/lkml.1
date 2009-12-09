Return-Path: <linux-kernel-owner+w=401wt.eu-S1757465AbZLIHy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465AbZLIHy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 02:54:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757438AbZLIHyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 02:54:14 -0500
Received: from rere.qmqm.pl ([89.167.52.164]:44277 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457AbZLIHyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 02:54:09 -0500
From: =?UTF-8?Q?Micha=C5=82=20Miros=C5=82aw=20?= 
	<mirq-linux@rere.qmqm.pl>
To: linux-kernel@vger.kernel.org
Message-ID: <5-1000-25639-1260344705-9533@rere.qmqm.pl>
In-Reply-To: <1-1000-25639-1260344705-9533@rere.qmqm.pl>
Date: Wed, 9 Dec 2009 06:04:39 +0100
Subject: [PATCH 4/7] x86/Kconfig.cpu: add CPU_SUP_AMD_32 and CPU_SUP_CENTAUR_32
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add CPU_SUP_AMD_32 and CPU_SUP_CENTAUR_32. Used later in selecting
possible MTRR implementations.

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
---
 arch/x86/Kconfig.cpu |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 08e442b..bae1193 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -462,6 +462,9 @@ config CPU_SUP_AMD
 
 	  If unsure, say N.
 
+config CPU_SUP_AMD_32
+	def_bool y if CPU_SUP_AMD && !64BIT
+
 config CPU_SUP_CENTAUR
 	default y
 	bool "Support Centaur processors" if PROCESSOR_SELECT
@@ -475,6 +478,9 @@ config CPU_SUP_CENTAUR
 
 	  If unsure, say N.
 
+config CPU_SUP_CENTAUR_32
+	def_bool y if CPU_SUP_CENTAUR && !64BIT
+
 config CPU_SUP_TRANSMETA_32
 	default y
 	bool "Support Transmeta processors" if PROCESSOR_SELECT
-- 
1.6.4.4

