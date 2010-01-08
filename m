Return-Path: <linux-kernel-owner+w=401wt.eu-S1753445Ab0AHMts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab0AHMts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 07:49:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393Ab0AHMtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 07:49:46 -0500
Received: from landau.phys.spbu.ru ([195.19.235.38]:37362 "EHLO
	landau.phys.spbu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab0AHMtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 07:49:45 -0500
From: Kirill Smelkov <kirr@landau.phys.spbu.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kirill Smelkov <kirr@landau.phys.spbu.ru>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] perf tools: fix annotate and top->annotate + more
Date: Fri,  8 Jan 2010 15:23:03 +0300
Message-Id: <cover.1262952612.git.kirr@landau.phys.spbu.ru>
X-Mailer: git-send-email 1.6.6.79.gd514e.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, All,

While studying perf, I've noticed `perf top` can't annotate userspace. Then I
also discovered that `perf annotate` wrongly annotates non-prelinked libraries.
Please find fixes below.

Kirill

Btw, thanks for nice tools.


Kirill Smelkov (6):
  perf top: teach it to autolocate vmlinux
  perf top: align help text on keys
  perf top: fix code typo in prompt_symbol()
  perf annotate: fix it for non-prelinked *.so
  perf top: fix annotate for userspace
  perf: fix few typos + cosmetics

 tools/perf/Documentation/perf-top.txt |    2 +-
 tools/perf/Documentation/perf.txt     |    2 +-
 tools/perf/builtin-annotate.c         |    4 +-
 tools/perf/builtin-top.c              |   67 +++++++++++++++++++--------------
 tools/perf/design.txt                 |    8 ++--
 tools/perf/util/map.c                 |   22 +++++++++++
 tools/perf/util/map.h                 |   10 +++++
 7 files changed, 79 insertions(+), 36 deletions(-)
