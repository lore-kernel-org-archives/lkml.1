Return-Path: <linux-kernel-owner+w=401wt.eu-S1754536AbZIXThW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbZIXThW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 15:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754516AbZIXThV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 15:37:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:40196 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448AbZIXThR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 15:37:17 -0400
Date: Thu, 24 Sep 2009 19:36:50 GMT
From: tip-bot for John Kacur <jkacur@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jkacur@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jkacur@redhat.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <alpine.LFD.2.00.0909241756530.11383@localhost.localdomain>
References: <alpine.LFD.2.00.0909241756530.11383@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Protect header files with a consistent style
Message-ID: <tip-8b40f521cf1c9750eab0c04da9075e7484675e9c@git.kernel.org>
Git-Commit-ID: 8b40f521cf1c9750eab0c04da9075e7484675e9c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 24 Sep 2009 19:36:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8b40f521cf1c9750eab0c04da9075e7484675e9c
Gitweb:     http://git.kernel.org/tip/8b40f521cf1c9750eab0c04da9075e7484675e9c
Author:     John Kacur <jkacur@redhat.com>
AuthorDate: Thu, 24 Sep 2009 18:02:18 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 24 Sep 2009 21:27:51 +0200

perf tools: Protect header files with a consistent style

There was a colorful mix of header guards - standardize them.

Signed-off-by: John Kacur <jkacur@redhat.com>
LKML-Reference: <alpine.LFD.2.00.0909241756530.11383@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/cache.h         |    6 +++---
 tools/perf/util/callchain.h     |    2 +-
 tools/perf/util/color.h         |    6 +++---
 tools/perf/util/debug.h         |    4 ++++
 tools/perf/util/event.h         |    3 ++-
 tools/perf/util/exec_cmd.h      |    6 +++---
 tools/perf/util/header.h        |    6 +++---
 tools/perf/util/help.h          |    6 +++---
 tools/perf/util/levenshtein.h   |    6 +++---
 tools/perf/util/module.h        |    6 +++---
 tools/perf/util/parse-events.h  |    6 +++---
 tools/perf/util/parse-options.h |    6 +++---
 tools/perf/util/quote.h         |    6 +++---
 tools/perf/util/run-command.h   |    6 +++---
 tools/perf/util/sigchain.h      |    6 +++---
 tools/perf/util/strbuf.h        |    6 +++---
 tools/perf/util/string.h        |    6 +++---
 tools/perf/util/strlist.h       |    6 +++---
 tools/perf/util/svghelper.h     |    6 +++---
 tools/perf/util/symbol.h        |    6 +++---
 tools/perf/util/thread.h        |    5 +++++
 tools/perf/util/trace-event.h   |    6 +++---
 tools/perf/util/types.h         |    6 +++---
 tools/perf/util/values.h        |    6 +++---
 24 files changed, 72 insertions(+), 62 deletions(-)

diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index 6f8ea9d..f26172c 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -1,5 +1,5 @@
-#ifndef CACHE_H
-#define CACHE_H
+#ifndef __PERF_CACHE_H
+#define __PERF_CACHE_H
 
 #include "util.h"
 #include "strbuf.h"
@@ -117,4 +117,4 @@ extern char *perf_pathdup(const char *fmt, ...)
 
 extern size_t strlcpy(char *dest, const char *src, size_t size);
 
-#endif /* CACHE_H */
+#endif /* __PERF_CACHE_H */
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 43cf3ea..ad4626d 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -58,4 +58,4 @@ static inline u64 cumul_hits(struct callchain_node *node)
 int register_callchain_param(struct callchain_param *param);
 void append_chain(struct callchain_node *root, struct ip_callchain *chain,
 		  struct symbol **syms);
-#endif
+#endif	/* __PERF_CALLCHAIN_H */
diff --git a/tools/perf/util/color.h b/tools/perf/util/color.h
index 58d5975..24e8809 100644
--- a/tools/perf/util/color.h
+++ b/tools/perf/util/color.h
@@ -1,5 +1,5 @@
-#ifndef COLOR_H
-#define COLOR_H
+#ifndef __PERF_COLOR_H
+#define __PERF_COLOR_H
 
 /* "\033[1;38;5;2xx;48;5;2xxm\0" is 23 bytes */
 #define COLOR_MAXLEN 24
@@ -39,4 +39,4 @@ int color_fwrite_lines(FILE *fp, const char *color, size_t count, const char *bu
 int percent_color_fprintf(FILE *fp, const char *fmt, double percent);
 const char *get_percent_color(double percent);
 
-#endif /* COLOR_H */
+#endif /* __PERF_COLOR_H */
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index 437eea5..02d1fa1 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -1,4 +1,6 @@
 /* For debugging general purposes */
+#ifndef __PERF_DEBUG_H
+#define __PERF_DEBUG_H
 
 extern int verbose;
 extern int dump_trace;
@@ -6,3 +8,5 @@ extern int dump_trace;
 int eprintf(const char *fmt, ...) __attribute__((format(printf, 1, 2)));
 int dump_printf(const char *fmt, ...) __attribute__((format(printf, 1, 2)));
 void trace_event(event_t *event);
+
+#endif	/* __PERF_DEBUG_H */
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 2c9c26d..c31a5da 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -1,5 +1,6 @@
 #ifndef __PERF_RECORD_H
 #define __PERF_RECORD_H
+
 #include "../perf.h"
 #include "util.h"
 #include <linux/list.h>
@@ -101,4 +102,4 @@ struct map *map__clone(struct map *self);
 int map__overlap(struct map *l, struct map *r);
 size_t map__fprintf(struct map *self, FILE *fp);
 
-#endif
+#endif /* __PERF_RECORD_H */
diff --git a/tools/perf/util/exec_cmd.h b/tools/perf/util/exec_cmd.h
index effe25e..31647ac 100644
--- a/tools/perf/util/exec_cmd.h
+++ b/tools/perf/util/exec_cmd.h
@@ -1,5 +1,5 @@
-#ifndef PERF_EXEC_CMD_H
-#define PERF_EXEC_CMD_H
+#ifndef __PERF_EXEC_CMD_H
+#define __PERF_EXEC_CMD_H
 
 extern void perf_set_argv_exec_path(const char *exec_path);
 extern const char *perf_extract_argv0_path(const char *path);
@@ -10,4 +10,4 @@ extern int execv_perf_cmd(const char **argv); /* NULL terminated */
 extern int execl_perf_cmd(const char *cmd, ...);
 extern const char *system_path(const char *path);
 
-#endif /* PERF_EXEC_CMD_H */
+#endif /* __PERF_EXEC_CMD_H */
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index a0761bc..a2916b6 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -1,5 +1,5 @@
-#ifndef _PERF_HEADER_H
-#define _PERF_HEADER_H
+#ifndef __PERF_HEADER_H
+#define __PERF_HEADER_H
 
 #include "../../../include/linux/perf_event.h"
 #include <sys/types.h>
@@ -44,4 +44,4 @@ perf_header__find_attr(u64 id, struct perf_header *header);
 
 struct perf_header *perf_header__new(void);
 
-#endif /* _PERF_HEADER_H */
+#endif /* __PERF_HEADER_H */
diff --git a/tools/perf/util/help.h b/tools/perf/util/help.h
index 7128783..7f5c6de 100644
--- a/tools/perf/util/help.h
+++ b/tools/perf/util/help.h
@@ -1,5 +1,5 @@
-#ifndef HELP_H
-#define HELP_H
+#ifndef __PERF_HELP_H
+#define __PERF_HELP_H
 
 struct cmdnames {
 	size_t alloc;
@@ -26,4 +26,4 @@ int is_in_cmdlist(struct cmdnames *c, const char *s);
 void list_commands(const char *title, struct cmdnames *main_cmds,
 		   struct cmdnames *other_cmds);
 
-#endif /* HELP_H */
+#endif /* __PERF_HELP_H */
diff --git a/tools/perf/util/levenshtein.h b/tools/perf/util/levenshtein.h
index 0173abe..b0fcb6d 100644
--- a/tools/perf/util/levenshtein.h
+++ b/tools/perf/util/levenshtein.h
@@ -1,8 +1,8 @@
-#ifndef LEVENSHTEIN_H
-#define LEVENSHTEIN_H
+#ifndef __PERF_LEVENSHTEIN_H
+#define __PERF_LEVENSHTEIN_H
 
 int levenshtein(const char *string1, const char *string2,
 	int swap_penalty, int substition_penalty,
 	int insertion_penalty, int deletion_penalty);
 
-#endif
+#endif /* __PERF_LEVENSHTEIN_H */
diff --git a/tools/perf/util/module.h b/tools/perf/util/module.h
index 8a592ef..098e041 100644
--- a/tools/perf/util/module.h
+++ b/tools/perf/util/module.h
@@ -1,5 +1,5 @@
-#ifndef _PERF_MODULE_
-#define _PERF_MODULE_ 1
+#ifndef __PERF_MODULE_
+#define __PERF_MODULE_ 1
 
 #include <linux/types.h>
 #include "../types.h"
@@ -50,4 +50,4 @@ size_t mod_dso__fprintf(struct mod_dso *self, FILE *fp);
 struct module *mod_dso__find_module(struct mod_dso *self, const char *name);
 int mod_dso__load_modules(struct mod_dso *dso);
 
-#endif /* _PERF_MODULE_ */
+#endif /* __PERF_MODULE_ */
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 30c6081..8626a43 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -1,5 +1,5 @@
-#ifndef _PARSE_EVENTS_H
-#define _PARSE_EVENTS_H
+#ifndef __PERF_PARSE_EVENTS_H
+#define __PERF_PARSE_EVENTS_H
 /*
  * Parse symbolic events/counts passed in as options:
  */
@@ -31,4 +31,4 @@ extern char debugfs_path[];
 extern int valid_debugfs_mount(const char *debugfs);
 
 
-#endif /* _PARSE_EVENTS_H */
+#endif /* __PERF_PARSE_EVENTS_H */
diff --git a/tools/perf/util/parse-options.h b/tools/perf/util/parse-options.h
index 2ee248f..948805a 100644
--- a/tools/perf/util/parse-options.h
+++ b/tools/perf/util/parse-options.h
@@ -1,5 +1,5 @@
-#ifndef PARSE_OPTIONS_H
-#define PARSE_OPTIONS_H
+#ifndef __PERF_PARSE_OPTIONS_H
+#define __PERF_PARSE_OPTIONS_H
 
 enum parse_opt_type {
 	/* special types */
@@ -174,4 +174,4 @@ extern int parse_opt_verbosity_cb(const struct option *, const char *, int);
 
 extern const char *parse_options_fix_filename(const char *prefix, const char *file);
 
-#endif
+#endif /* __PERF_PARSE_OPTIONS_H */
diff --git a/tools/perf/util/quote.h b/tools/perf/util/quote.h
index a5454a1..b6a0197 100644
--- a/tools/perf/util/quote.h
+++ b/tools/perf/util/quote.h
@@ -1,5 +1,5 @@
-#ifndef QUOTE_H
-#define QUOTE_H
+#ifndef __PERF_QUOTE_H
+#define __PERF_QUOTE_H
 
 #include <stddef.h>
 #include <stdio.h>
@@ -65,4 +65,4 @@ extern void perl_quote_print(FILE *stream, const char *src);
 extern void python_quote_print(FILE *stream, const char *src);
 extern void tcl_quote_print(FILE *stream, const char *src);
 
-#endif
+#endif /* __PERF_QUOTE_H */
diff --git a/tools/perf/util/run-command.h b/tools/perf/util/run-command.h
index cc1837d..d790287 100644
--- a/tools/perf/util/run-command.h
+++ b/tools/perf/util/run-command.h
@@ -1,5 +1,5 @@
-#ifndef RUN_COMMAND_H
-#define RUN_COMMAND_H
+#ifndef __PERF_RUN_COMMAND_H
+#define __PERF_RUN_COMMAND_H
 
 enum {
 	ERR_RUN_COMMAND_FORK = 10000,
@@ -85,4 +85,4 @@ struct async {
 int start_async(struct async *async);
 int finish_async(struct async *async);
 
-#endif
+#endif /* __PERF_RUN_COMMAND_H */
diff --git a/tools/perf/util/sigchain.h b/tools/perf/util/sigchain.h
index 618083b..1a53c11 100644
--- a/tools/perf/util/sigchain.h
+++ b/tools/perf/util/sigchain.h
@@ -1,5 +1,5 @@
-#ifndef SIGCHAIN_H
-#define SIGCHAIN_H
+#ifndef __PERF_SIGCHAIN_H
+#define __PERF_SIGCHAIN_H
 
 typedef void (*sigchain_fun)(int);
 
@@ -8,4 +8,4 @@ int sigchain_pop(int sig);
 
 void sigchain_push_common(sigchain_fun f);
 
-#endif /* SIGCHAIN_H */
+#endif /* __PERF_SIGCHAIN_H */
diff --git a/tools/perf/util/strbuf.h b/tools/perf/util/strbuf.h
index d2aa86c..a3d121d 100644
--- a/tools/perf/util/strbuf.h
+++ b/tools/perf/util/strbuf.h
@@ -1,5 +1,5 @@
-#ifndef STRBUF_H
-#define STRBUF_H
+#ifndef __PERF_STRBUF_H
+#define __PERF_STRBUF_H
 
 /*
  * Strbuf's can be use in many ways: as a byte array, or to store arbitrary
@@ -134,4 +134,4 @@ extern int launch_editor(const char *path, struct strbuf *buffer, const char *co
 extern int strbuf_branchname(struct strbuf *sb, const char *name);
 extern int strbuf_check_branch_ref(struct strbuf *sb, const char *name);
 
-#endif /* STRBUF_H */
+#endif /* __PERF_STRBUF_H */
diff --git a/tools/perf/util/string.h b/tools/perf/util/string.h
index bf39dfa..15c8274 100644
--- a/tools/perf/util/string.h
+++ b/tools/perf/util/string.h
@@ -1,5 +1,5 @@
-#ifndef _PERF_STRING_H_
-#define _PERF_STRING_H_
+#ifndef __PERF_STRING_H_
+#define __PERF_STRING_H_
 
 #include "types.h"
 
@@ -8,4 +8,4 @@ int hex2u64(const char *ptr, u64 *val);
 #define _STR(x) #x
 #define STR(x) _STR(x)
 
-#endif
+#endif /* __PERF_STRING_H */
diff --git a/tools/perf/util/strlist.h b/tools/perf/util/strlist.h
index 921818e..cb46593 100644
--- a/tools/perf/util/strlist.h
+++ b/tools/perf/util/strlist.h
@@ -1,5 +1,5 @@
-#ifndef STRLIST_H_
-#define STRLIST_H_
+#ifndef __PERF_STRLIST_H
+#define __PERF_STRLIST_H
 
 #include <linux/rbtree.h>
 #include <stdbool.h>
@@ -36,4 +36,4 @@ static inline unsigned int strlist__nr_entries(const struct strlist *self)
 }
 
 int strlist__parse_list(struct strlist *self, const char *s);
-#endif /* STRLIST_H_ */
+#endif /* __PERF_STRLIST_H */
diff --git a/tools/perf/util/svghelper.h b/tools/perf/util/svghelper.h
index cd93195..e078198 100644
--- a/tools/perf/util/svghelper.h
+++ b/tools/perf/util/svghelper.h
@@ -1,5 +1,5 @@
-#ifndef _INCLUDE_GUARD_SVG_HELPER_
-#define _INCLUDE_GUARD_SVG_HELPER_
+#ifndef __PERF_SVGHELPER_H
+#define __PERF_SVGHELPER_H
 
 #include "types.h"
 
@@ -25,4 +25,4 @@ extern void svg_close(void);
 
 extern int svg_page_width;
 
-#endif
+#endif /* __PERF_SVGHELPER_H */
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 6e84907..ee164f6 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -1,5 +1,5 @@
-#ifndef _PERF_SYMBOL_
-#define _PERF_SYMBOL_ 1
+#ifndef __PERF_SYMBOL
+#define __PERF_SYMBOL 1
 
 #include <linux/types.h>
 #include "types.h"
@@ -89,4 +89,4 @@ extern struct dso *vdso;
 extern struct dso *hypervisor_dso;
 extern const char *vmlinux_name;
 extern int   modules;
-#endif /* _PERF_SYMBOL_ */
+#endif /* __PERF_SYMBOL */
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 32aea3c..693ed1e 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -1,3 +1,6 @@
+#ifndef __PERF_THREAD_H
+#define __PERF_THREAD_H
+
 #include <linux/rbtree.h>
 #include <linux/list.h>
 #include <unistd.h>
@@ -20,3 +23,5 @@ void thread__insert_map(struct thread *self, struct map *map);
 int thread__fork(struct thread *self, struct thread *parent);
 struct map *thread__find_map(struct thread *self, u64 ip);
 size_t threads__fprintf(FILE *fp, struct rb_root *threads);
+
+#endif	/* __PERF_THREAD_H */
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 693f815..162c3e6 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -1,5 +1,5 @@
-#ifndef _TRACE_EVENTS_H
-#define _TRACE_EVENTS_H
+#ifndef __PERF_TRACE_EVENTS_H
+#define __PERF_TRACE_EVENTS_H
 
 #include "parse-events.h"
 
@@ -242,4 +242,4 @@ void *raw_field_ptr(struct event *event, const char *name, void *data);
 
 void read_tracing_data(struct perf_event_attr *pattrs, int nb_events);
 
-#endif /* _TRACE_EVENTS_H */
+#endif /* __PERF_TRACE_EVENTS_H */
diff --git a/tools/perf/util/types.h b/tools/perf/util/types.h
index 5e75f90..7d6b833 100644
--- a/tools/perf/util/types.h
+++ b/tools/perf/util/types.h
@@ -1,5 +1,5 @@
-#ifndef _PERF_TYPES_H
-#define _PERF_TYPES_H
+#ifndef __PERF_TYPES_H
+#define __PERF_TYPES_H
 
 /*
  * We define u64 as unsigned long long for every architecture
@@ -14,4 +14,4 @@ typedef signed short	   s16;
 typedef unsigned char	   u8;
 typedef signed char	   s8;
 
-#endif /* _PERF_TYPES_H */
+#endif /* __PERF_TYPES_H */
diff --git a/tools/perf/util/values.h b/tools/perf/util/values.h
index cadf8cf..2fa967e 100644
--- a/tools/perf/util/values.h
+++ b/tools/perf/util/values.h
@@ -1,5 +1,5 @@
-#ifndef _PERF_VALUES_H
-#define _PERF_VALUES_H
+#ifndef __PERF_VALUES_H
+#define __PERF_VALUES_H
 
 #include "types.h"
 
@@ -24,4 +24,4 @@ void perf_read_values_add_value(struct perf_read_values *values,
 void perf_read_values_display(FILE *fp, struct perf_read_values *values,
 			      int raw);
 
-#endif /* _PERF_VALUES_H */
+#endif /* __PERF_VALUES_H */
