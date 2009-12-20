Return-Path: <linux-kernel-owner+w=401wt.eu-S1751086AbZLTFWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751086AbZLTFWo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 00:22:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750841AbZLTFWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 00:22:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:55646 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbZLTFWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 00:22:42 -0500
Date: Sun, 20 Dec 2009 05:21:38 GMT
From: tip-bot for Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, pq@iki.fi,
       tglx@linutronix.de, randy.dunlap@oracle.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       pq@iki.fi, tglx@linutronix.de, randy.dunlap@oracle.com, mingo@elte.hu
In-Reply-To: <4B2C0D68.6080401@oracle.com>
References: <4B2C0D68.6080401@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] Documentation: Update mmiotrace.txt
Message-ID: <tip-360b6e5cab1cea1d838b0100956ce0d3dbccbb6f@git.kernel.org>
Git-Commit-ID: 360b6e5cab1cea1d838b0100956ce0d3dbccbb6f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  360b6e5cab1cea1d838b0100956ce0d3dbccbb6f
Gitweb:     http://git.kernel.org/tip/360b6e5cab1cea1d838b0100956ce0d3dbccbb6f
Author:     Randy Dunlap <randy.dunlap@oracle.com>
AuthorDate: Fri, 18 Dec 2009 15:16:56 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 20 Dec 2009 06:18:23 +0100

Documentation: Update mmiotrace.txt

Fix typos, spellos, hyphenation, line lengths.

BTW:  are there some userspace tools?  There is a reference to
some at the wiki page, but there are no tools listed there.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Pekka Paalanen <pq@iki.fi>
LKML-Reference: <4B2C0D68.6080401@oracle.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/trace/mmiotrace.txt |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/Documentation/trace/mmiotrace.txt b/Documentation/trace/mmiotrace.txt
index 162effb..664e738 100644
--- a/Documentation/trace/mmiotrace.txt
+++ b/Documentation/trace/mmiotrace.txt
@@ -44,7 +44,8 @@ Check for lost events.
 Usage
 -----
 
-Make sure debugfs is mounted to /sys/kernel/debug. If not, (requires root privileges)
+Make sure debugfs is mounted to /sys/kernel/debug.
+If not (requires root privileges):
 $ mount -t debugfs debugfs /sys/kernel/debug
 
 Check that the driver you are about to trace is not loaded.
@@ -91,7 +92,7 @@ $ dmesg > dmesg.txt
 $ tar zcf pciid-nick-mmiotrace.tar.gz mydump.txt lspci.txt dmesg.txt
 and then send the .tar.gz file. The trace compresses considerably. Replace
 "pciid" and "nick" with the PCI ID or model name of your piece of hardware
-under investigation and your nick name.
+under investigation and your nickname.
 
 
 How Mmiotrace Works
@@ -100,7 +101,7 @@ How Mmiotrace Works
 Access to hardware IO-memory is gained by mapping addresses from PCI bus by
 calling one of the ioremap_*() functions. Mmiotrace is hooked into the
 __ioremap() function and gets called whenever a mapping is created. Mapping is
-an event that is recorded into the trace log. Note, that ISA range mappings
+an event that is recorded into the trace log. Note that ISA range mappings
 are not caught, since the mapping always exists and is returned directly.
 
 MMIO accesses are recorded via page faults. Just before __ioremap() returns,
@@ -122,11 +123,11 @@ Trace Log Format
 ----------------
 
 The raw log is text and easily filtered with e.g. grep and awk. One record is
-one line in the log. A record starts with a keyword, followed by keyword
-dependant arguments. Arguments are separated by a space, or continue until the
+one line in the log. A record starts with a keyword, followed by keyword-
+dependent arguments. Arguments are separated by a space, or continue until the
 end of line. The format for version 20070824 is as follows:
 
-Explanation	Keyword	Space separated arguments
+Explanation	Keyword	Space-separated arguments
 ---------------------------------------------------------------------------
 
 read event	R	width, timestamp, map id, physical, value, PC, PID
@@ -136,7 +137,7 @@ iounmap event	UNMAP	timestamp, map id, PC, PID
 marker		MARK	timestamp, text
 version		VERSION	the string "20070824"
 info for reader	LSPCI	one line from lspci -v
-PCI address map	PCIDEV	space separated /proc/bus/pci/devices data
+PCI address map	PCIDEV	space-separated /proc/bus/pci/devices data
 unk. opcode	UNKNOWN	timestamp, map id, physical, data, PC, PID
 
 Timestamp is in seconds with decimals. Physical is a PCI bus address, virtual
