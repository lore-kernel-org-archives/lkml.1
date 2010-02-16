Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933610Ab0BPXrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 18:47:23 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:18295 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757044Ab0BPXrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 18:47:21 -0500
Message-ID: <4B7B2E19.4060602@oracle.com>
Date: Tue, 16 Feb 2010 15:45:29 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] Doc/SubmitChecklist: add rule #1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4B7B2E59.009B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add header file requirements.
Complements of Stephen Rothwell.

Stephen calls this Rule #1, so I put it there, but I
didn't want to demote any of the others in the list,
so I made one of them number 2b.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
---
 Documentation/SubmitChecklist |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- lnx-2633-rc8.orig/Documentation/SubmitChecklist
+++ lnx-2633-rc8/Documentation/SubmitChecklist
@@ -9,10 +9,14 @@ Documentation/SubmittingPatches and else
 kernel patches.
 
 
-1: Builds cleanly with applicable or modified CONFIG options =y, =m, and
+1: If you use a facility then #include the file that defines/declares
+   that facility.  Don't depend on other header files pulling in ones
+   that you use.
+
+2: Builds cleanly with applicable or modified CONFIG options =y, =m, and
    =n.  No gcc warnings/errors, no linker warnings/errors.
 
-2: Passes allnoconfig, allmodconfig
+2b: Passes allnoconfig, allmodconfig
 
 3: Builds on multiple CPU architectures by using local cross-compile tools
    or some other build farm.
