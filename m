Return-Path: <linux-kernel-owner+w=401wt.eu-S1756366AbZGEP7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366AbZGEP7d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 11:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753084AbZGEP7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 11:59:25 -0400
Received: from zakalwe.fi ([80.83.5.154]:40102 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203AbZGEP7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 11:59:24 -0400
Date: Sun, 5 Jul 2009 18:59:25 +0300
From: Heikki Orsila <heikki.orsila@iki.fi>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix spelling: "userpace" -> "userspace", "cachemiss" -> "cache miss"
Message-ID: <20090705155925.GA8905@zakalwe.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Heikki Orsila <heikki.orsila@iki.fi>
---
 arch/mips/kernel/kgdb.c            |    2 +-
 arch/parisc/kernel/perf_images.h   |    2 +-
 fs/Kconfig                         |    2 +-
 init/Kconfig                       |    2 +-
 net/mac80211/rc80211_pid_debugfs.c |    2 +-
 net/wireless/reg.c                 |    2 +-
 tools/perf/design.txt              |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/mips/kernel/kgdb.c b/arch/mips/kernel/kgdb.c
index 50c9bb8..5df7c09 100644
--- a/arch/mips/kernel/kgdb.c
+++ b/arch/mips/kernel/kgdb.c
@@ -191,7 +191,7 @@ static int kgdb_mips_notify(struct notifier_block *self, unsigned long cmd,
 	struct pt_regs *regs = args->regs;
 	int trap = (regs->cp0_cause & 0x7c) >> 2;
 
-	/* Userpace events, ignore. */
+	/* Userspace events, ignore. */
 	if (user_mode(regs))
 		return NOTIFY_DONE;
 
diff --git a/arch/parisc/kernel/perf_images.h b/arch/parisc/kernel/perf_images.h
index 7fef964..a54fcab 100644
--- a/arch/parisc/kernel/perf_images.h
+++ b/arch/parisc/kernel/perf_images.h
@@ -2945,7 +2945,7 @@ static uint32_t cuda_images[][PCXW_IMAGE_SIZE/sizeof(uint32_t)] __read_mostly =
    0xffffffff,   0xffffffff,   0xffffffff,   0xffffffff,
    },
 
-/* cachemiss image    FROM I_D_MISSES.IDF  (Image 19)
+/* cache miss image    FROM I_D_MISSES.IDF  (Image 19)
  *
  * ctr0 : icache misses for retired instructions
  * ctr1 : total cycles
diff --git a/fs/Kconfig b/fs/Kconfig
index a97263b..22dbc7e 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -63,7 +63,7 @@ source "fs/autofs4/Kconfig"
 source "fs/fuse/Kconfig"
 
 config CUSE
-	tristate "Character device in Userpace support"
+	tristate "Character device in Userspace support"
 	depends on FUSE_FS
 	help
 	  This FUSE extension allows character devices to be
diff --git a/init/Kconfig b/init/Kconfig
index 1ce05a4..9c7fecf 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -947,7 +947,7 @@ config PERF_COUNTERS
 
 	  Performance counters are special hardware registers available
 	  on most modern CPUs. These registers count the number of certain
-	  types of hw events: such as instructions executed, cachemisses
+	  types of hw events: such as instructions executed, cache misses
 	  suffered, or branches mis-predicted - without slowing down the
 	  kernel or applications. These registers can also trigger interrupts
 	  when a threshold number of events have passed - and can thus be
diff --git a/net/mac80211/rc80211_pid_debugfs.c b/net/mac80211/rc80211_pid_debugfs.c
index a08a9b5..7440089 100644
--- a/net/mac80211/rc80211_pid_debugfs.c
+++ b/net/mac80211/rc80211_pid_debugfs.c
@@ -160,7 +160,7 @@ static ssize_t rate_control_pid_events_read(struct file *file, char __user *buf,
 	file_info->next_entry = (file_info->next_entry + 1) %
 				RC_PID_EVENT_RING_SIZE;
 
-	/* Print information about the event. Note that userpace needs to
+	/* Print information about the event. Note that userspace needs to
 	 * provide large enough buffers. */
 	length = length < RC_PID_PRINT_BUF_SIZE ?
 		 length : RC_PID_PRINT_BUF_SIZE;
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 5e14371..af81083 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2291,7 +2291,7 @@ int regulatory_init(void)
 	 * The old code still requests for a new regdomain and if
 	 * you have CRDA you get it updated, otherwise you get
 	 * stuck with the static values. Since "EU" is not a valid
-	 * ISO / IEC 3166 alpha2 code we can't expect userpace to
+	 * ISO / IEC 3166 alpha2 code we can't expect userspace to
 	 * give us a regulatory domain for it. We need last_request
 	 * iniitalized though so lets just send a request which we
 	 * know will be ignored... this crap will be removed once
diff --git a/tools/perf/design.txt b/tools/perf/design.txt
index f71e0d2..1177569 100644
--- a/tools/perf/design.txt
+++ b/tools/perf/design.txt
@@ -4,7 +4,7 @@ Performance Counters for Linux
 
 Performance counters are special hardware registers available on most modern
 CPUs. These registers count the number of certain types of hw events: such
-as instructions executed, cachemisses suffered, or branches mis-predicted -
+as instructions executed, cache misses suffered, or branches mis-predicted -
 without slowing down the kernel or applications. These registers can also
 trigger interrupts when a threshold number of events have passed - and can
 thus be used to profile the code that runs on that CPU.
-- 
1.6.1.2
