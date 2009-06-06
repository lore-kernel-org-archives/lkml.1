Return-Path: <linux-kernel-owner+w=401wt.eu-S1753274AbZFFStt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbZFFStt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 14:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbZFFSte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 14:49:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:34364 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358AbZFFSta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 14:49:30 -0400
Date: Sat, 6 Jun 2009 18:48:33 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter tools: Move from Documentation/perf_counter/ to tools/perf/
Message-ID: <tip-864709302a80f26fa9da3be5b47304f0b8bae192@git.kernel.org>
Git-Commit-ID: 864709302a80f26fa9da3be5b47304f0b8bae192
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 06 Jun 2009 18:48:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  864709302a80f26fa9da3be5b47304f0b8bae192
Gitweb:     http://git.kernel.org/tip/864709302a80f26fa9da3be5b47304f0b8bae192
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sat, 6 Jun 2009 20:33:43 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 6 Jun 2009 20:33:43 +0200

perf_counter tools: Move from Documentation/perf_counter/ to tools/perf/

Several people have suggested that 'perf' has become a full-fledged
tool that should be moved out of Documentation/. Move it to the
(new) tools/ directory.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 .../perf_counter => tools/perf}/.gitignore         |    0
 .../perf}/Documentation/Makefile                   |    0
 .../perf}/Documentation/asciidoc.conf              |    0
 .../perf}/Documentation/manpage-1.72.xsl           |    0
 .../perf}/Documentation/manpage-base.xsl           |    0
 .../perf}/Documentation/manpage-bold-literal.xsl   |    0
 .../perf}/Documentation/manpage-normal.xsl         |    0
 .../perf}/Documentation/manpage-suppress-sp.xsl    |    0
 .../perf}/Documentation/perf-annotate.txt          |    0
 .../perf}/Documentation/perf-help.txt              |    0
 .../perf}/Documentation/perf-list.txt              |    0
 .../perf}/Documentation/perf-record.txt            |    0
 .../perf}/Documentation/perf-report.txt            |    0
 .../perf}/Documentation/perf-stat.txt              |    0
 .../perf}/Documentation/perf-top.txt               |    0
 .../perf}/Documentation/perf.txt                   |    0
 .../perf_counter => tools/perf}/Makefile           |    0
 .../perf_counter => tools/perf}/builtin-annotate.c |    0
 .../perf_counter => tools/perf}/builtin-help.c     |    0
 .../perf_counter => tools/perf}/builtin-list.c     |    0
 .../perf_counter => tools/perf}/builtin-record.c   |    0
 .../perf_counter => tools/perf}/builtin-report.c   |    0
 .../perf_counter => tools/perf}/builtin-stat.c     |    0
 .../perf_counter => tools/perf}/builtin-top.c      |    0
 .../perf_counter => tools/perf}/builtin.h          |    0
 .../perf_counter => tools/perf}/command-list.txt   |    0
 .../perf_counter => tools/perf}/design.txt         |    0
 {Documentation/perf_counter => tools/perf}/perf.c  |    0
 {Documentation/perf_counter => tools/perf}/perf.h  |    0
 .../perf}/util/PERF-VERSION-GEN                    |    0
 .../perf_counter => tools/perf}/util/abspath.c     |    0
 .../perf_counter => tools/perf}/util/alias.c       |    0
 .../perf_counter => tools/perf}/util/cache.h       |    0
 .../perf_counter => tools/perf}/util/color.c       |    0
 .../perf_counter => tools/perf}/util/color.h       |    0
 .../perf_counter => tools/perf}/util/config.c      |    0
 .../perf_counter => tools/perf}/util/ctype.c       |    0
 .../perf_counter => tools/perf}/util/environment.c |    0
 .../perf_counter => tools/perf}/util/exec_cmd.c    |    0
 .../perf_counter => tools/perf}/util/exec_cmd.h    |    0
 .../perf}/util/generate-cmdlist.sh                 |    0
 .../perf_counter => tools/perf}/util/help.c        |    0
 .../perf_counter => tools/perf}/util/help.h        |    0
 .../perf_counter => tools/perf}/util/levenshtein.c |    0
 .../perf_counter => tools/perf}/util/levenshtein.h |    0
 .../perf_counter => tools/perf}/util/list.h        |    0
 .../perf_counter => tools/perf}/util/pager.c       |    0
 .../perf}/util/parse-events.c                      |    0
 .../perf}/util/parse-events.h                      |    0
 .../perf}/util/parse-options.c                     |    0
 .../perf}/util/parse-options.h                     |    0
 .../perf_counter => tools/perf}/util/path.c        |    0
 .../perf_counter => tools/perf}/util/quote.c       |    0
 .../perf_counter => tools/perf}/util/quote.h       |    0
 .../perf_counter => tools/perf}/util/rbtree.c      |    0
 .../perf_counter => tools/perf}/util/rbtree.h      |    0
 .../perf_counter => tools/perf}/util/run-command.c |    0
 .../perf_counter => tools/perf}/util/run-command.h |    0
 .../perf_counter => tools/perf}/util/sigchain.c    |    0
 .../perf_counter => tools/perf}/util/sigchain.h    |    0
 .../perf_counter => tools/perf}/util/strbuf.c      |    0
 .../perf_counter => tools/perf}/util/strbuf.h      |    0
 .../perf_counter => tools/perf}/util/string.c      |    0
 .../perf_counter => tools/perf}/util/string.h      |    0
 .../perf_counter => tools/perf}/util/symbol.c      |    0
 .../perf_counter => tools/perf}/util/symbol.h      |    0
 .../perf_counter => tools/perf}/util/usage.c       |    0
 .../perf_counter => tools/perf}/util/util.h        |    0
 .../perf_counter => tools/perf}/util/wrapper.c     |    0
 69 files changed, 0 insertions(+), 0 deletions(-)

diff --git a/Documentation/perf_counter/.gitignore b/tools/perf/.gitignore
similarity index 100%
rename from Documentation/perf_counter/.gitignore
rename to tools/perf/.gitignore
diff --git a/Documentation/perf_counter/Documentation/Makefile b/tools/perf/Documentation/Makefile
similarity index 100%
rename from Documentation/perf_counter/Documentation/Makefile
rename to tools/perf/Documentation/Makefile
diff --git a/Documentation/perf_counter/Documentation/asciidoc.conf b/tools/perf/Documentation/asciidoc.conf
similarity index 100%
rename from Documentation/perf_counter/Documentation/asciidoc.conf
rename to tools/perf/Documentation/asciidoc.conf
diff --git a/Documentation/perf_counter/Documentation/manpage-1.72.xsl b/tools/perf/Documentation/manpage-1.72.xsl
similarity index 100%
rename from Documentation/perf_counter/Documentation/manpage-1.72.xsl
rename to tools/perf/Documentation/manpage-1.72.xsl
diff --git a/Documentation/perf_counter/Documentation/manpage-base.xsl b/tools/perf/Documentation/manpage-base.xsl
similarity index 100%
rename from Documentation/perf_counter/Documentation/manpage-base.xsl
rename to tools/perf/Documentation/manpage-base.xsl
diff --git a/Documentation/perf_counter/Documentation/manpage-bold-literal.xsl b/tools/perf/Documentation/manpage-bold-literal.xsl
similarity index 100%
rename from Documentation/perf_counter/Documentation/manpage-bold-literal.xsl
rename to tools/perf/Documentation/manpage-bold-literal.xsl
diff --git a/Documentation/perf_counter/Documentation/manpage-normal.xsl b/tools/perf/Documentation/manpage-normal.xsl
similarity index 100%
rename from Documentation/perf_counter/Documentation/manpage-normal.xsl
rename to tools/perf/Documentation/manpage-normal.xsl
diff --git a/Documentation/perf_counter/Documentation/manpage-suppress-sp.xsl b/tools/perf/Documentation/manpage-suppress-sp.xsl
similarity index 100%
rename from Documentation/perf_counter/Documentation/manpage-suppress-sp.xsl
rename to tools/perf/Documentation/manpage-suppress-sp.xsl
diff --git a/Documentation/perf_counter/Documentation/perf-annotate.txt b/tools/perf/Documentation/perf-annotate.txt
similarity index 100%
rename from Documentation/perf_counter/Documentation/perf-annotate.txt
rename to tools/perf/Documentation/perf-annotate.txt
diff --git a/Documentation/perf_counter/Documentation/perf-help.txt b/tools/perf/Documentation/perf-help.txt
similarity index 100%
rename from Documentation/perf_counter/Documentation/perf-help.txt
rename to tools/perf/Documentation/perf-help.txt
diff --git a/Documentation/perf_counter/Documentation/perf-list.txt b/tools/perf/Documentation/perf-list.txt
similarity index 100%
rename from Documentation/perf_counter/Documentation/perf-list.txt
rename to tools/perf/Documentation/perf-list.txt
diff --git a/Documentation/perf_counter/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
similarity index 100%
rename from Documentation/perf_counter/Documentation/perf-record.txt
rename to tools/perf/Documentation/perf-record.txt
diff --git a/Documentation/perf_counter/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
similarity index 100%
rename from Documentation/perf_counter/Documentation/perf-report.txt
rename to tools/perf/Documentation/perf-report.txt
diff --git a/Documentation/perf_counter/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
similarity index 100%
rename from Documentation/perf_counter/Documentation/perf-stat.txt
rename to tools/perf/Documentation/perf-stat.txt
diff --git a/Documentation/perf_counter/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
similarity index 100%
rename from Documentation/perf_counter/Documentation/perf-top.txt
rename to tools/perf/Documentation/perf-top.txt
diff --git a/Documentation/perf_counter/Documentation/perf.txt b/tools/perf/Documentation/perf.txt
similarity index 100%
rename from Documentation/perf_counter/Documentation/perf.txt
rename to tools/perf/Documentation/perf.txt
diff --git a/Documentation/perf_counter/Makefile b/tools/perf/Makefile
similarity index 100%
rename from Documentation/perf_counter/Makefile
rename to tools/perf/Makefile
diff --git a/Documentation/perf_counter/builtin-annotate.c b/tools/perf/builtin-annotate.c
similarity index 100%
rename from Documentation/perf_counter/builtin-annotate.c
rename to tools/perf/builtin-annotate.c
diff --git a/Documentation/perf_counter/builtin-help.c b/tools/perf/builtin-help.c
similarity index 100%
rename from Documentation/perf_counter/builtin-help.c
rename to tools/perf/builtin-help.c
diff --git a/Documentation/perf_counter/builtin-list.c b/tools/perf/builtin-list.c
similarity index 100%
rename from Documentation/perf_counter/builtin-list.c
rename to tools/perf/builtin-list.c
diff --git a/Documentation/perf_counter/builtin-record.c b/tools/perf/builtin-record.c
similarity index 100%
rename from Documentation/perf_counter/builtin-record.c
rename to tools/perf/builtin-record.c
diff --git a/Documentation/perf_counter/builtin-report.c b/tools/perf/builtin-report.c
similarity index 100%
rename from Documentation/perf_counter/builtin-report.c
rename to tools/perf/builtin-report.c
diff --git a/Documentation/perf_counter/builtin-stat.c b/tools/perf/builtin-stat.c
similarity index 100%
rename from Documentation/perf_counter/builtin-stat.c
rename to tools/perf/builtin-stat.c
diff --git a/Documentation/perf_counter/builtin-top.c b/tools/perf/builtin-top.c
similarity index 100%
rename from Documentation/perf_counter/builtin-top.c
rename to tools/perf/builtin-top.c
diff --git a/Documentation/perf_counter/builtin.h b/tools/perf/builtin.h
similarity index 100%
rename from Documentation/perf_counter/builtin.h
rename to tools/perf/builtin.h
diff --git a/Documentation/perf_counter/command-list.txt b/tools/perf/command-list.txt
similarity index 100%
rename from Documentation/perf_counter/command-list.txt
rename to tools/perf/command-list.txt
diff --git a/Documentation/perf_counter/design.txt b/tools/perf/design.txt
similarity index 100%
rename from Documentation/perf_counter/design.txt
rename to tools/perf/design.txt
diff --git a/Documentation/perf_counter/perf.c b/tools/perf/perf.c
similarity index 100%
rename from Documentation/perf_counter/perf.c
rename to tools/perf/perf.c
diff --git a/Documentation/perf_counter/perf.h b/tools/perf/perf.h
similarity index 100%
rename from Documentation/perf_counter/perf.h
rename to tools/perf/perf.h
diff --git a/Documentation/perf_counter/util/PERF-VERSION-GEN b/tools/perf/util/PERF-VERSION-GEN
similarity index 100%
rename from Documentation/perf_counter/util/PERF-VERSION-GEN
rename to tools/perf/util/PERF-VERSION-GEN
diff --git a/Documentation/perf_counter/util/abspath.c b/tools/perf/util/abspath.c
similarity index 100%
rename from Documentation/perf_counter/util/abspath.c
rename to tools/perf/util/abspath.c
diff --git a/Documentation/perf_counter/util/alias.c b/tools/perf/util/alias.c
similarity index 100%
rename from Documentation/perf_counter/util/alias.c
rename to tools/perf/util/alias.c
diff --git a/Documentation/perf_counter/util/cache.h b/tools/perf/util/cache.h
similarity index 100%
rename from Documentation/perf_counter/util/cache.h
rename to tools/perf/util/cache.h
diff --git a/Documentation/perf_counter/util/color.c b/tools/perf/util/color.c
similarity index 100%
rename from Documentation/perf_counter/util/color.c
rename to tools/perf/util/color.c
diff --git a/Documentation/perf_counter/util/color.h b/tools/perf/util/color.h
similarity index 100%
rename from Documentation/perf_counter/util/color.h
rename to tools/perf/util/color.h
diff --git a/Documentation/perf_counter/util/config.c b/tools/perf/util/config.c
similarity index 100%
rename from Documentation/perf_counter/util/config.c
rename to tools/perf/util/config.c
diff --git a/Documentation/perf_counter/util/ctype.c b/tools/perf/util/ctype.c
similarity index 100%
rename from Documentation/perf_counter/util/ctype.c
rename to tools/perf/util/ctype.c
diff --git a/Documentation/perf_counter/util/environment.c b/tools/perf/util/environment.c
similarity index 100%
rename from Documentation/perf_counter/util/environment.c
rename to tools/perf/util/environment.c
diff --git a/Documentation/perf_counter/util/exec_cmd.c b/tools/perf/util/exec_cmd.c
similarity index 100%
rename from Documentation/perf_counter/util/exec_cmd.c
rename to tools/perf/util/exec_cmd.c
diff --git a/Documentation/perf_counter/util/exec_cmd.h b/tools/perf/util/exec_cmd.h
similarity index 100%
rename from Documentation/perf_counter/util/exec_cmd.h
rename to tools/perf/util/exec_cmd.h
diff --git a/Documentation/perf_counter/util/generate-cmdlist.sh b/tools/perf/util/generate-cmdlist.sh
similarity index 100%
rename from Documentation/perf_counter/util/generate-cmdlist.sh
rename to tools/perf/util/generate-cmdlist.sh
diff --git a/Documentation/perf_counter/util/help.c b/tools/perf/util/help.c
similarity index 100%
rename from Documentation/perf_counter/util/help.c
rename to tools/perf/util/help.c
diff --git a/Documentation/perf_counter/util/help.h b/tools/perf/util/help.h
similarity index 100%
rename from Documentation/perf_counter/util/help.h
rename to tools/perf/util/help.h
diff --git a/Documentation/perf_counter/util/levenshtein.c b/tools/perf/util/levenshtein.c
similarity index 100%
rename from Documentation/perf_counter/util/levenshtein.c
rename to tools/perf/util/levenshtein.c
diff --git a/Documentation/perf_counter/util/levenshtein.h b/tools/perf/util/levenshtein.h
similarity index 100%
rename from Documentation/perf_counter/util/levenshtein.h
rename to tools/perf/util/levenshtein.h
diff --git a/Documentation/perf_counter/util/list.h b/tools/perf/util/list.h
similarity index 100%
rename from Documentation/perf_counter/util/list.h
rename to tools/perf/util/list.h
diff --git a/Documentation/perf_counter/util/pager.c b/tools/perf/util/pager.c
similarity index 100%
rename from Documentation/perf_counter/util/pager.c
rename to tools/perf/util/pager.c
diff --git a/Documentation/perf_counter/util/parse-events.c b/tools/perf/util/parse-events.c
similarity index 100%
rename from Documentation/perf_counter/util/parse-events.c
rename to tools/perf/util/parse-events.c
diff --git a/Documentation/perf_counter/util/parse-events.h b/tools/perf/util/parse-events.h
similarity index 100%
rename from Documentation/perf_counter/util/parse-events.h
rename to tools/perf/util/parse-events.h
diff --git a/Documentation/perf_counter/util/parse-options.c b/tools/perf/util/parse-options.c
similarity index 100%
rename from Documentation/perf_counter/util/parse-options.c
rename to tools/perf/util/parse-options.c
diff --git a/Documentation/perf_counter/util/parse-options.h b/tools/perf/util/parse-options.h
similarity index 100%
rename from Documentation/perf_counter/util/parse-options.h
rename to tools/perf/util/parse-options.h
diff --git a/Documentation/perf_counter/util/path.c b/tools/perf/util/path.c
similarity index 100%
rename from Documentation/perf_counter/util/path.c
rename to tools/perf/util/path.c
diff --git a/Documentation/perf_counter/util/quote.c b/tools/perf/util/quote.c
similarity index 100%
rename from Documentation/perf_counter/util/quote.c
rename to tools/perf/util/quote.c
diff --git a/Documentation/perf_counter/util/quote.h b/tools/perf/util/quote.h
similarity index 100%
rename from Documentation/perf_counter/util/quote.h
rename to tools/perf/util/quote.h
diff --git a/Documentation/perf_counter/util/rbtree.c b/tools/perf/util/rbtree.c
similarity index 100%
rename from Documentation/perf_counter/util/rbtree.c
rename to tools/perf/util/rbtree.c
diff --git a/Documentation/perf_counter/util/rbtree.h b/tools/perf/util/rbtree.h
similarity index 100%
rename from Documentation/perf_counter/util/rbtree.h
rename to tools/perf/util/rbtree.h
diff --git a/Documentation/perf_counter/util/run-command.c b/tools/perf/util/run-command.c
similarity index 100%
rename from Documentation/perf_counter/util/run-command.c
rename to tools/perf/util/run-command.c
diff --git a/Documentation/perf_counter/util/run-command.h b/tools/perf/util/run-command.h
similarity index 100%
rename from Documentation/perf_counter/util/run-command.h
rename to tools/perf/util/run-command.h
diff --git a/Documentation/perf_counter/util/sigchain.c b/tools/perf/util/sigchain.c
similarity index 100%
rename from Documentation/perf_counter/util/sigchain.c
rename to tools/perf/util/sigchain.c
diff --git a/Documentation/perf_counter/util/sigchain.h b/tools/perf/util/sigchain.h
similarity index 100%
rename from Documentation/perf_counter/util/sigchain.h
rename to tools/perf/util/sigchain.h
diff --git a/Documentation/perf_counter/util/strbuf.c b/tools/perf/util/strbuf.c
similarity index 100%
rename from Documentation/perf_counter/util/strbuf.c
rename to tools/perf/util/strbuf.c
diff --git a/Documentation/perf_counter/util/strbuf.h b/tools/perf/util/strbuf.h
similarity index 100%
rename from Documentation/perf_counter/util/strbuf.h
rename to tools/perf/util/strbuf.h
diff --git a/Documentation/perf_counter/util/string.c b/tools/perf/util/string.c
similarity index 100%
rename from Documentation/perf_counter/util/string.c
rename to tools/perf/util/string.c
diff --git a/Documentation/perf_counter/util/string.h b/tools/perf/util/string.h
similarity index 100%
rename from Documentation/perf_counter/util/string.h
rename to tools/perf/util/string.h
diff --git a/Documentation/perf_counter/util/symbol.c b/tools/perf/util/symbol.c
similarity index 100%
rename from Documentation/perf_counter/util/symbol.c
rename to tools/perf/util/symbol.c
diff --git a/Documentation/perf_counter/util/symbol.h b/tools/perf/util/symbol.h
similarity index 100%
rename from Documentation/perf_counter/util/symbol.h
rename to tools/perf/util/symbol.h
diff --git a/Documentation/perf_counter/util/usage.c b/tools/perf/util/usage.c
similarity index 100%
rename from Documentation/perf_counter/util/usage.c
rename to tools/perf/util/usage.c
diff --git a/Documentation/perf_counter/util/util.h b/tools/perf/util/util.h
similarity index 100%
rename from Documentation/perf_counter/util/util.h
rename to tools/perf/util/util.h
diff --git a/Documentation/perf_counter/util/wrapper.c b/tools/perf/util/wrapper.c
similarity index 100%
rename from Documentation/perf_counter/util/wrapper.c
rename to tools/perf/util/wrapper.c
