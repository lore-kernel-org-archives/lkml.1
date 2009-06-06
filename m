Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbZFFN2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbZFFN2Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 09:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbZFFN2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 09:28:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:57854 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbZFFN2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 09:28:08 -0400
Date: Sat, 6 Jun 2009 13:27:36 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter tools: Add help for perf list
Message-ID: <tip-386b05e3a2f3c5b0a9c5575060421cca0911648a@git.kernel.org>
Git-Commit-ID: 386b05e3a2f3c5b0a9c5575060421cca0911648a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 06 Jun 2009 13:27:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  386b05e3a2f3c5b0a9c5575060421cca0911648a
Gitweb:     http://git.kernel.org/tip/386b05e3a2f3c5b0a9c5575060421cca0911648a
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 6 Jun 2009 14:56:33 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 6 Jun 2009 15:23:49 +0200

perf_counter tools: Add help for perf list

Also update other areas of the help texts.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 .../perf_counter/Documentation/perf-list.txt       |   25 +++++++++++++++++++
 .../perf_counter/Documentation/perf-record.txt     |   26 ++++----------------
 .../perf_counter/Documentation/perf-stat.txt       |   26 ++++----------------
 .../perf_counter/Documentation/perf-top.txt        |   26 ++++----------------
 Documentation/perf_counter/Documentation/perf.txt  |    3 +-
 5 files changed, 42 insertions(+), 64 deletions(-)

diff --git a/Documentation/perf_counter/Documentation/perf-list.txt b/Documentation/perf_counter/Documentation/perf-list.txt
new file mode 100644
index 0000000..aa55a71
--- /dev/null
+++ b/Documentation/perf_counter/Documentation/perf-list.txt
@@ -0,0 +1,25 @@
+perf-list(1)
+==============
+
+NAME
+----
+perf-list - List all symbolic event types
+
+SYNOPSIS
+--------
+[verse]
+'perf list
+
+DESCRIPTION
+-----------
+This command displays the symbolic event types which can be selected in the
+various perf commands with the -e option.
+
+OPTIONS
+-------
+None
+
+SEE ALSO
+--------
+linkperf:perf-stat[1], linkperf:perf-top[1],
+linkperf:perf-record[1]
diff --git a/Documentation/perf_counter/Documentation/perf-record.txt b/Documentation/perf_counter/Documentation/perf-record.txt
index 4d3416f..1dbc1ee 100644
--- a/Documentation/perf_counter/Documentation/perf-record.txt
+++ b/Documentation/perf_counter/Documentation/perf-record.txt
@@ -26,26 +26,10 @@ OPTIONS
 
 -e::
 --event=::
-                             0:0: cpu-cycles          
-                             0:0: cycles              
-                             0:1: instructions        
-                             0:2: cache-references    
-                             0:3: cache-misses        
-                             0:4: branch-instructions 
-                             0:4: branches            
-                             0:5: branch-misses       
-                             0:6: bus-cycles          
-                             1:0: cpu-clock           
-                             1:1: task-clock          
-                             1:2: page-faults         
-                             1:2: faults              
-                             1:5: minor-faults        
-                             1:6: major-faults        
-                             1:3: context-switches    
-                             1:3: cs                  
-                             1:4: cpu-migrations      
-                             1:4: migrations          
-                           rNNN: raw PMU events (eventsel+umask)
+	Select the PMU event. Selection can be a symbolic event name
+	(use 'perf list' to list all events) or a raw PMU
+	event (eventsel+umask) in the form of rNNN where NNN is a
+	 hexadecimal event descriptor.
 
 -a::
         system-wide collection
@@ -55,4 +39,4 @@ OPTIONS
 
 SEE ALSO
 --------
-linkperf:perf-stat[1]
+linkperf:perf-stat[1], linkperf:perf-list[1]
diff --git a/Documentation/perf_counter/Documentation/perf-stat.txt b/Documentation/perf_counter/Documentation/perf-stat.txt
index a340e7b..5d95784 100644
--- a/Documentation/perf_counter/Documentation/perf-stat.txt
+++ b/Documentation/perf_counter/Documentation/perf-stat.txt
@@ -25,26 +25,10 @@ OPTIONS
 
 -e::
 --event=::
-                             0:0: cpu-cycles          
-                             0:0: cycles              
-                             0:1: instructions        
-                             0:2: cache-references    
-                             0:3: cache-misses        
-                             0:4: branch-instructions 
-                             0:4: branches            
-                             0:5: branch-misses       
-                             0:6: bus-cycles          
-                             1:0: cpu-clock           
-                             1:1: task-clock          
-                             1:2: page-faults         
-                             1:2: faults              
-                             1:5: minor-faults        
-                             1:6: major-faults        
-                             1:3: context-switches    
-                             1:3: cs                  
-                             1:4: cpu-migrations      
-                             1:4: migrations          
-                           rNNN: raw PMU events (eventsel+umask)
+	Select the PMU event. Selection can be a symbolic event name
+	(use 'perf list' to list all events) or a raw PMU
+	event (eventsel+umask) in the form of rNNN where NNN is a
+	 hexadecimal event descriptor.
 
 -i::
 --inherit::
@@ -79,4 +63,4 @@ $ perf stat -- make -j
 
 SEE ALSO
 --------
-linkperf:perf-tops[1]
+linkperf:perf-top[1], linkperf:perf-list[1]
diff --git a/Documentation/perf_counter/Documentation/perf-top.txt b/Documentation/perf_counter/Documentation/perf-top.txt
index 15251e4..c8eb7cf 100644
--- a/Documentation/perf_counter/Documentation/perf-top.txt
+++ b/Documentation/perf_counter/Documentation/perf-top.txt
@@ -23,26 +23,10 @@ OPTIONS
 
 -e::
 --event=::
-                             0:0: cpu-cycles          
-                             0:0: cycles              
-                             0:1: instructions        
-                             0:2: cache-references    
-                             0:3: cache-misses        
-                             0:4: branch-instructions 
-                             0:4: branches            
-                             0:5: branch-misses       
-                             0:6: bus-cycles          
-                             1:0: cpu-clock           
-                             1:1: task-clock          
-                             1:2: page-faults         
-                             1:2: faults              
-                             1:5: minor-faults        
-                             1:6: major-faults        
-                             1:3: context-switches    
-                             1:3: cs                  
-                             1:4: cpu-migrations      
-                             1:4: migrations          
-                           rNNN: raw PMU events (eventsel+umask)
+	Select the PMU event. Selection can be a symbolic event name
+	(use 'perf list' to list all events) or a raw PMU
+	event (eventsel+umask) in the form of rNNN where NNN is a
+	 hexadecimal event descriptor.
 
 -a::
         system-wide collection
@@ -52,4 +36,4 @@ OPTIONS
 
 SEE ALSO
 --------
-linkperf:perf-stat[1]
+linkperf:perf-stat[1], linkperf:perf-list[1]
diff --git a/Documentation/perf_counter/Documentation/perf.txt b/Documentation/perf_counter/Documentation/perf.txt
index e3d8b38..69c8325 100644
--- a/Documentation/perf_counter/Documentation/perf.txt
+++ b/Documentation/perf_counter/Documentation/perf.txt
@@ -20,4 +20,5 @@ and software features (software counters, tracepoints) as well.
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-top[1],
-linkperf:perf-record[1], linkperf:perf-report[1]
+linkperf:perf-record[1], linkperf:perf-report[1],
+linkperf:perf-list[1]
