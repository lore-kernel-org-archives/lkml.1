Return-Path: <linux-kernel-owner+w=401wt.eu-S1758375AbZJEC0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758375AbZJEC0x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 22:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758364AbZJEC0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 22:26:53 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:39034 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758346AbZJEC0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 22:26:52 -0400
Message-ID: <4AC95891.3000707@oracle.com>
Date: Sun, 04 Oct 2009 19:23:13 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: trivial@kernel.org, nhorman@tuxdriver.com
Subject: [PATCH trivial] docs: fix core_pipe_limit info
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4AC958FD.004D:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix typos in core_pipe_limit info.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
---
 Documentation/sysctl/kernel.txt |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-next-20090930.orig/Documentation/sysctl/kernel.txt
+++ linux-next-20090930/Documentation/sysctl/kernel.txt
@@ -139,9 +139,9 @@ core_pattern is used to specify a core d
 core_pipe_limit:
 
 This sysctl is only applicable when core_pattern is configured to pipe core
-files to user space helper a (when the first character of core_pattern is a '|',
+files to a user space helper (when the first character of core_pattern is a '|',
 see above).  When collecting cores via a pipe to an application, it is
-occasionally usefull for the collecting application to gather data about the
+occasionally useful for the collecting application to gather data about the
 crashing process from its /proc/pid directory.  In order to do this safely, the
 kernel must wait for the collecting process to exit, so as not to remove the
 crashing processes proc files prematurely.  This in turn creates the possibility
@@ -152,7 +152,7 @@ applications in parallel.  If this value
 processes above that value are noted via the kernel log and their cores are
 skipped.  0 is a special value, indicating that unlimited processes may be
 captured in parallel, but that no waiting will take place (i.e. the collecting
-process is not guaranteed access to /proc/<crahing pid>/).  This value defaults
+process is not guaranteed access to /proc/<crashing pid>/).  This value defaults
 to 0.
 
 ==============================================================
