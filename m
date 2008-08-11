Return-Path: <linux-kernel-owner+w=401wt.eu-S1757962AbYHKUQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962AbYHKUQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 16:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757360AbYHKUN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 16:13:26 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:41144 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbYHKUNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 16:13:18 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 00/17] checkpatch: update to version 0.22
Date: Mon, 11 Aug 2008 21:12:55 +0100
Message-Id: <1218485592-6679-1-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.rc1.258.g80295
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This update brings some bigger fixes to indent checking, some fixes
for false positives, and some tightening of some tests.  Of note:

  - major fixes to indent checking including selection of the right output
    lines,
  - comment detection improved, and
  - reporting absolute filenames.

Complete changelog below.

-apw

Andy Whitcroft (17):
  checkpatch: square brackets -- exemption for array slices in braces
  checkpatch: values: double ampersand may be unary
  checkpatch: conditional indent -- labels have different indent rules
  checkpatch: switch indent allow plain return
  checkpatch: add tests for the attribute matcher
  checkpatch: ____cacheline_aligned et al are modifiers
  checkpatch: complex macros -- fix up extension handling
  checkpatch: fix up comment checks search to scan the entire block
  checkpatch: include/asm checks should be anchored
  checkpatch: reduce warnings for #include of asm/foo.h to check from
    arch/bar.c
  checkpatch: report any absolute references to kernel source files
  checkpatch: report the real first line of all suspect indents
  checkpatch: suspect indent -- skip over preprocessor, label and blank
    lines
  checkpatch: %Lx tests should hand %% as a literal
  checkpatch: report the correct lines for single statement blocks
  checkpatch: perform indent checks on perl
  checkpatch: version: 0.22

