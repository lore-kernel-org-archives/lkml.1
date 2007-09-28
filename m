Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbXI1VcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbXI1VcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 17:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbXI1VcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 17:32:08 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:55843 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbXI1VcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 17:32:07 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] 0/3 coding standards documentation/code updates
Date: Fri, 28 Sep 2007 17:31:59 -0400
Message-Id: <11910151223214-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The following is a series of patches related to coding standards.  The first
patch updates the CodingStandards document with respect to printk debugging
and un/likely use; the second patch updates the usage string for
checkpatch.pl; the third patch introduces a new small perl script that can
be used to check coding-standards compliance on multiple source files.  This
new script, called check-coding-standards.pl, produces output in a standard
compiler-error format, which can be parsed by assorted tools including text
editors and help users locate the file that had the error and the offending
line-number more quickly.

Erez Zadok (3):
      CodingStyle updates
      Update usage string for checkpatch.pl
      New script to check coding-style compliance on multiple regular files

 Documentation/CodingStyle         |   88 +++++++++++++++++++++++++++++++++++++-
 scripts/check-coding-standards.pl |   59 +++++++++++++++++++++++++
 scripts/checkpatch.pl             |    1 
 3 files changed, 146 insertions(+), 2 deletions(-)

---
Erez Zadok
ezk@cs.sunysb.edu
