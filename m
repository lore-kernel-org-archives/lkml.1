Return-Path: <linux-kernel-owner+w=401wt.eu-S1757433AbZHQIgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433AbZHQIgi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 04:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757423AbZHQIgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 04:36:37 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:34188 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757147AbZHQIgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 04:36:36 -0400
X-Greylist: delayed 517 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Aug 2009 04:36:36 EDT
From: Reinhard Tartler <siretart@tauware.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, linux-kbuild@vger.kernel.org
Subject: [PATCH] cpumask: fix typo s/CONFIG_CPU_HOTPLUG/CONFIG_HOTPLUG_CPU/
Date: Mon, 17 Aug 2009 10:19:33 +0200
Organization: Uni Erlangen, Informatik 4, Lehrstuhl =?utf-8?Q?f=C3=BCr?=
 Betriebs- und verteile Systeme
X-Url: http://www4.informatik.uni-erlangen.de/~tartler
Message-ID: <rwuzl9y975c.fsf@faui48a.informatik.uni-erlangen.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In ./arch/*/Kconfig, this Kconfig symbol is defined as HOTPLUG_CPU, and
never as CPU_HOTPLUG

Signed-off-by: Reinhard Tartler <siretart@tauware.de>
---
 kernel/smp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index ad63d85..94188b8 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -57,7 +57,7 @@ hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
 			return NOTIFY_BAD;
 		break;
 
-#ifdef CONFIG_CPU_HOTPLUG
+#ifdef CONFIG_HOTPLUG_CPU
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
 
-- 
1.5.6.5


-- 
Reinhard Tartler                     Department of Computer Science IV
Martensstr 1, 91058 Erlangen Germany, University of Erlangen-Nuremberg
            http://www4.informatik.uni-erlangen.de/~tartler
