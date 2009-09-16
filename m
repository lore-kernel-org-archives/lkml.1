Return-Path: <linux-kernel-owner+w=401wt.eu-S1760136AbZIPVk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760136AbZIPVk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 17:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754959AbZIPVk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 17:40:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:32043 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760066AbZIPVkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 17:40:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=UjhhN25dW/+yACVegSR2NplWJ4muQRu2Z1cyQ1r+BoUsPC9icLesdo16p6fTU38PSI
         FGxJymchj3IgPlqmI7FVjlgpUQ6WuQXOFAYHWNnAlQP8491hgDgy73XNFPvgNdu0sPUE
         fi9A1G+cMG/eArFBushtLqvuRa6TcDTCwvkBs=
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Felipe Contreras <felipe.contreras@gmail.com>, Len Brown <lenb@kernel.org>,
       Len Brown <len.brown@intel.com>, Lin Ming <ming.m.lin@intel.com>,
       Bob Moore <robert.moore@intel.com>, Andi Kleen <ak@linux.intel.com>,
       linux-acpi@vger.kernel.org
Subject: [PATCH v2 4/6] acpi: fix a bunch of style issues on 'actypes.h'
Date: Thu, 17 Sep 2009 00:38:41 +0300
Message-Id: <1253137123-18047-5-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.6.5.rc1
In-Reply-To: <1253137123-18047-4-git-send-email-felipe.contreras@gmail.com>
References: <1253137123-18047-1-git-send-email-felipe.contreras@gmail.com>
 <1253137123-18047-2-git-send-email-felipe.contreras@gmail.com>
 <1253137123-18047-3-git-send-email-felipe.contreras@gmail.com>
 <1253137123-18047-4-git-send-email-felipe.contreras@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many still remain.

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 include/acpi/actypes.h |   36 ++++++++++++++++++------------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/include/acpi/actypes.h b/include/acpi/actypes.h
index 37ba576..2d500fa 100644
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
@@ -777,7 +777,7 @@ typedef u8 acpi_adr_space_type;
 #define ACPI_BITREG_ARB_DISABLE                 0x13
 
 #define ACPI_BITREG_MAX                         0x13
-#define ACPI_NUM_BITREG                         ACPI_BITREG_MAX + 1
+#define ACPI_NUM_BITREG                         (ACPI_BITREG_MAX + 1)
 
 /* Status register values. A 1 clears a status bit. 0 = no effect */
 
@@ -944,7 +944,7 @@ typedef
 acpi_status(*acpi_adr_space_handler) (u32 function,
 				      acpi_physical_address address,
 				      u32 bit_width,
-				      acpi_integer * value,
+				      acpi_integer *value,
 				      void *handler_context,
 				      void *region_context);
 
-- 
1.6.5.rc1

