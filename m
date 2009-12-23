Return-Path: <linux-kernel-owner+w=401wt.eu-S1756584AbZLWRwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584AbZLWRwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 12:52:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753892AbZLWRwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 12:52:20 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:55892 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbZLWRwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 12:52:20 -0500
Date: Wed, 23 Dec 2009 09:49:23 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH] documentation: update kernel-doc-nano-HOWTO information
Message-Id: <20091223094923.44266893.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090208.4B325894.01BC:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Remove comments about function short descriptions not allowed to be
on multiple lines (that was fixed/changed recently).

Add comments that function "section header:" names need to be
unique per function/struct/union/typedef/enum.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/kernel-doc-nano-HOWTO.txt |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- linux-2.6.33-rc1-git3.orig/Documentation/kernel-doc-nano-HOWTO.txt
+++ linux-2.6.33-rc1-git3/Documentation/kernel-doc-nano-HOWTO.txt
@@ -214,11 +214,13 @@ The format of the block comment is like 
  * (section header: (section description)? )*
 (*)?*/
 
-The short function description ***cannot be multiline***, but the other
-descriptions can be (and they can contain blank lines).  If you continue
-that initial short description onto a second line, that second line will
-appear further down at the beginning of the description section, which is
-almost certainly not what you had in mind.
+All "description" text can span multiple lines, although the
+function_name & its short description are traditionally on a single line.
+Description text may also contain blank lines (i.e., lines that contain
+only a "*").
+
+"section header:" names must be unique per function (or struct,
+union, typedef, enum).
 
 Avoid putting a spurious blank line after the function name, or else the
 description will be repeated!
