Return-Path: <linux-kernel-owner+w=401wt.eu-S1757385AbYAVX4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385AbYAVX4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 18:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbYAVX4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 18:56:08 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:43580 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015AbYAVX4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 18:56:07 -0500
Date: Wed, 23 Jan 2008 01:54:39 +0200
From: Adrian Bunk <bunk@kernel.org>
To: zippel@linux-m68k.org, Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] kconfig: remove "enable"
Message-ID: <20080122235439.GJ26556@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kconfig had a synonym "enable" for "select" that was neither documented 
nor used.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 scripts/kconfig/zconf.gperf          |    1 -
 scripts/kconfig/zconf.hash.c_shipped |   14 +++++++-------
 2 files changed, 7 insertions(+), 8 deletions(-)

6b3161305f33144e2ae5227bbf32221e2310371d 
diff --git a/scripts/kconfig/zconf.gperf b/scripts/kconfig/zconf.gperf
index 93538e5..2196816 100644
--- a/scripts/kconfig/zconf.gperf
+++ b/scripts/kconfig/zconf.gperf
@@ -35,7 +35,6 @@ int,		T_TYPE,		TF_COMMAND, S_INT
 hex,		T_TYPE,		TF_COMMAND, S_HEX
 string,		T_TYPE,		TF_COMMAND, S_STRING
 select,		T_SELECT,	TF_COMMAND
-enable,		T_SELECT,	TF_COMMAND
 range,		T_RANGE,	TF_COMMAND
 option,		T_OPTION,	TF_COMMAND
 on,		T_ON,		TF_PARAM
diff --git a/scripts/kconfig/zconf.hash.c_shipped b/scripts/kconfig/zconf.hash.c_shipped
index ab28b18..fb66a5d 100644
--- a/scripts/kconfig/zconf.hash.c_shipped
+++ b/scripts/kconfig/zconf.hash.c_shipped
@@ -1,4 +1,4 @@
-/* ANSI-C code produced by gperf version 3.0.2 */
+/* ANSI-C code produced by gperf version 3.0.3 */
 /* Command-line: gperf  */
 /* Computed positions: -k'1,3' */
 
@@ -53,7 +53,7 @@ kconf_id_hash (register const char *str, register unsigned int len)
       49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
       49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
       49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 18, 11,  5,
+      49, 49, 49, 49, 49, 49, 49, 49, 11,  5,
        0,  0,  5, 49,  5, 20, 49, 49,  5, 20,
        5,  0, 30, 49,  0, 15,  0, 10, 49, 49,
       25, 49, 49, 49, 49, 49, 49, 49, 49, 49,
@@ -107,7 +107,6 @@ struct kconf_id_strings_t
     char kconf_id_strings_str21[sizeof("string")];
     char kconf_id_strings_str22[sizeof("if")];
     char kconf_id_strings_str23[sizeof("int")];
-    char kconf_id_strings_str24[sizeof("enable")];
     char kconf_id_strings_str26[sizeof("select")];
     char kconf_id_strings_str27[sizeof("modules")];
     char kconf_id_strings_str28[sizeof("tristate")];
@@ -141,7 +140,6 @@ static struct kconf_id_strings_t kconf_id_strings_contents =
     "string",
     "if",
     "int",
-    "enable",
     "select",
     "modules",
     "tristate",
@@ -157,13 +155,16 @@ static struct kconf_id_strings_t kconf_id_strings_contents =
 #define kconf_id_strings ((const char *) &kconf_id_strings_contents)
 #ifdef __GNUC__
 __inline
+#ifdef __GNUC_STDC_INLINE__
+__attribute__ ((__gnu_inline__))
+#endif
 #endif
 struct kconf_id *
 kconf_id_lookup (register const char *str, register unsigned int len)
 {
   enum
     {
-      TOTAL_KEYWORDS = 31,
+      TOTAL_KEYWORDS = 30,
       MIN_WORD_LENGTH = 2,
       MAX_WORD_LENGTH = 14,
       MIN_HASH_VALUE = 2,
@@ -194,8 +195,7 @@ kconf_id_lookup (register const char *str, register unsigned int len)
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str21,		T_TYPE,		TF_COMMAND, S_STRING},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str22,		T_IF,		TF_COMMAND|TF_PARAM},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str23,		T_TYPE,		TF_COMMAND, S_INT},
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str24,		T_SELECT,	TF_COMMAND},
-      {-1},
+      {-1}, {-1},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str26,		T_SELECT,	TF_COMMAND},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str27,	T_OPT_MODULES,	TF_OPTION},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str28,	T_TYPE,		TF_COMMAND, S_TRISTATE},

