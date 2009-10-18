Return-Path: <linux-kernel-owner+w=401wt.eu-S932115AbZJRW54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115AbZJRW54 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 18:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932099AbZJRW5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 18:57:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:34026 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098AbZJRW5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 18:57:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=M37Orz5VvjXDVsO7Jeeav2/f/85Fn2n2XEB+em3XJBfEKF7yR+aTtpZlDiuYDaJXXe
         D25fu1sGO/fbDn4calpgB4RabzSYZzOPt6/ZTwlaJhKpFPVY2HWMprWsfp6mBn/tqJH8
         tUAtpacRTD4jpVMVMn5gwb+w/LiGyqRoWn0AY=
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org,
       Felipe Contreras <felipe.contreras@gmail.com>,
       Len Brown <lenb@kernel.org>, Bob Moore <robert.moore@intel.com>,
       Lin Ming <ming.m.lin@intel.com>, linux-acpi@vger.kernel.org
Subject: [PATCH 5/7] acpi: fix a bunch of style issues on 'actypes.h'
Date: Mon, 19 Oct 2009 01:54:32 +0300
Message-Id: <1255906474-25091-6-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <1255906474-25091-1-git-send-email-felipe.contreras@gmail.com>
References: <1255906474-25091-1-git-send-email-felipe.contreras@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many still remain.

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 include/acpi/actypes.h |   36 ++++++++++++++++++------------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/include/acpi/actypes.h b/include/acpi/actypes.h
index 153f12d..c1a0eb4 100644
--- a/include/acpi/actypes.h
+++ b/include/acpi/actypes.h
@@ -167,7 +167,7 @@ typedef u64 acpi_physical_address;
  * Note: Em64_t and other X86-64 processors support misaligned transfers,
  * so there is no need to define this flag.
  */
-#if defined (__IA64__) || defined (__ia64__)
+#if defined(__IA64__) || defined(__ia64__)
 #define ACPI_MISALIGNMENT_NOT_SUPPORTED
 #endif
 
@@ -242,10 +242,10 @@ typedef u32 acpi_physical_address;
  * Map the OSL Mutex interfaces to binary semaphores.
  */
 #define acpi_mutex                      acpi_semaphore
-#define acpi_os_create_mutex(out_handle) acpi_os_create_semaphore (1, 1, out_handle)
-#define acpi_os_delete_mutex(handle)    (void) acpi_os_delete_semaphore (handle)
-#define acpi_os_acquire_mutex(handle,time) acpi_os_wait_semaphore (handle, 1, time)
-#define acpi_os_release_mutex(handle)   (void) acpi_os_signal_semaphore (handle, 1)
+#define acpi_os_create_mutex(out_handle) acpi_os_create_semaphore(1, 1, out_handle)
+#define acpi_os_delete_mutex(handle)    (void) acpi_os_delete_semaphore(handle)
+#define acpi_os_acquire_mutex(handle, time) acpi_os_wait_semaphore(handle, 1, time)
+#define acpi_os_release_mutex(handle)   (void) acpi_os_signal_semaphore(handle, 1)
 #endif
 
 /* Configurable types for synchronization objects */
@@ -417,7 +417,7 @@ typedef unsigned long long acpi_integer;
 /*
  * Constants with special meanings
  */
-#define ACPI_ROOT_OBJECT                ACPI_ADD_PTR (acpi_handle, NULL, ACPI_MAX_PTR)
+#define ACPI_ROOT_OBJECT                ACPI_ADD_PTR(acpi_handle, NULL, ACPI_MAX_PTR)
 #define ACPI_WAIT_FOREVER               0xFFFF	/* u16, as per ACPI spec */
 #define ACPI_DO_NOT_WAIT                0
 
@@ -438,8 +438,8 @@ typedef unsigned long long acpi_integer;
 
 #define ACPI_SET_BIT(target,bit)        ((target) |= (bit))
 #define ACPI_CLEAR_BIT(target,bit)      ((target) &= ~(bit))
-#define ACPI_MIN(a,b)                   (((a)<(b))?(a):(b))
-#define ACPI_MAX(a,b)                   (((a)>(b))?(a):(b))
+#define ACPI_MIN(a, b)                  (((a)<(b))?(a):(b))
+#define ACPI_MAX(a, b)                  (((a)>(b))?(a):(b))
 
 /* Size calculation */
 
@@ -449,21 +449,21 @@ typedef unsigned long long acpi_integer;
 
 #define ACPI_CAST_PTR(t, p)             ((t *) (acpi_uintptr_t) (p))
 #define ACPI_CAST_INDIRECT_PTR(t, p)    ((t **) (acpi_uintptr_t) (p))
-#define ACPI_ADD_PTR(t, a, b)           ACPI_CAST_PTR (t, (ACPI_CAST_PTR (u8, (a)) + (acpi_size)(b)))
-#define ACPI_PTR_DIFF(a, b)             (acpi_size) (ACPI_CAST_PTR (u8, (a)) - ACPI_CAST_PTR (u8, (b)))
+#define ACPI_ADD_PTR(t, a, b)           ACPI_CAST_PTR(t, (ACPI_CAST_PTR(u8, (a)) + (acpi_size)(b)))
+#define ACPI_PTR_DIFF(a, b)             (acpi_size) (ACPI_CAST_PTR(u8, (a)) - ACPI_CAST_PTR(u8, (b)))
 
 /* Pointer/Integer type conversions */
 
-#define ACPI_TO_POINTER(i)              ACPI_ADD_PTR (void, (void *) NULL,(acpi_size) i)
-#define ACPI_TO_INTEGER(p)              ACPI_PTR_DIFF (p, (void *) NULL)
-#define ACPI_OFFSET(d, f)               (acpi_size) ACPI_PTR_DIFF (&(((d *)0)->f), (void *) NULL)
+#define ACPI_TO_POINTER(i)              ACPI_ADD_PTR(void, (void *) NULL, (acpi_size) i)
+#define ACPI_TO_INTEGER(p)              ACPI_PTR_DIFF(p, (void *) NULL)
+#define ACPI_OFFSET(d, f)               (acpi_size) ACPI_PTR_DIFF(&(((d *)0)->f), (void *) NULL)
 #define ACPI_PHYSADDR_TO_PTR(i)         ACPI_TO_POINTER(i)
 #define ACPI_PTR_TO_PHYSADDR(i)         ACPI_TO_INTEGER(i)
 
 #ifndef ACPI_MISALIGNMENT_NOT_SUPPORTED
-#define ACPI_COMPARE_NAME(a,b)          (*ACPI_CAST_PTR (u32, (a)) == *ACPI_CAST_PTR (u32, (b)))
+#define ACPI_COMPARE_NAME(a, b)         (*ACPI_CAST_PTR(u32, (a)) == *ACPI_CAST_PTR(u32, (b)))
 #else
-#define ACPI_COMPARE_NAME(a,b)          (!ACPI_STRNCMP (ACPI_CAST_PTR (char, (a)), ACPI_CAST_PTR (char, (b)), ACPI_NAME_SIZE))
+#define ACPI_COMPARE_NAME(a, b)         (!ACPI_STRNCMP(ACPI_CAST_PTR(char, (a)), ACPI_CAST_PTR(char, (b)), ACPI_NAME_SIZE))
 #endif
 
 /*******************************************************************************
@@ -631,7 +631,7 @@ typedef u32 acpi_event_type;
 #define ACPI_EVENT_SLEEP_BUTTON         3
 #define ACPI_EVENT_RTC                  4
 #define ACPI_EVENT_MAX                  4
-#define ACPI_NUM_FIXED_EVENTS           ACPI_EVENT_MAX + 1
+#define ACPI_NUM_FIXED_EVENTS           (ACPI_EVENT_MAX + 1)
 
 /*
  * Event Status - Per event
@@ -778,7 +778,7 @@ typedef u8 acpi_adr_space_type;
 #define ACPI_BITREG_ARB_DISABLE                 0x13
 
 #define ACPI_BITREG_MAX                         0x13
-#define ACPI_NUM_BITREG                         ACPI_BITREG_MAX + 1
+#define ACPI_NUM_BITREG                         (ACPI_BITREG_MAX + 1)
 
 /* Status register values. A 1 clears a status bit. 0 = no effect */
 
@@ -945,7 +945,7 @@ typedef
 acpi_status(*acpi_adr_space_handler) (u32 function,
 				      acpi_physical_address address,
 				      u32 bit_width,
-				      acpi_integer * value,
+				      acpi_integer *value,
 				      void *handler_context,
 				      void *region_context);
 
-- 
1.6.5.1

