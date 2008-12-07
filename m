Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbYLGSbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbYLGSbe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 13:31:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754056AbYLGSa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 13:30:59 -0500
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:55693 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbYLGSa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 13:30:58 -0500
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 00/13] update checkpatch to version 0.26
Date: Sun,  7 Dec 2008 18:30:37 +0000
Message-Id: <1228674650-24392-1-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.4.911.gc990
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This update brings a couple of new checks, and a number of fixes.  Of note:

 - allows parentheses on return of comparisons
 - tracks #ifdef sections better
 - fixes miss reports of variables containing static

It also updates the maintainers entry to track my new email address and
to drop inactive maintainers.

Complete changelog below.

-apw

Andy Whitcroft (11):
  checkpatch: update MAINTAINERS entry
  checkpatch: update copyrights
  checkpatch: allow parentheses on return for comparisons
  checkpatch: loosen spacing on typedef function checks
  checkpatch: fix continuation detection when handling spacing on operators
  checkpatch: track #ifdef/#else/#endif when tracking blocks
  checkpatch: do not report nr_static as a static declaration
  checkpatch: ensure we actually detect if assignments split across lines
  checkpatch: struct file_operations should normally be const
  checkpatch: fix the perlcritic errors
  checkpatch: version: 0.26

Mike Frysinger (1):
  checkpatch: try to catch missing VMLINUX_SYMBOL() in vmlinux.lds.h

Wolfram Sang (1):
  checkpatch: Add warning for p0-patches

 scripts/checkpatch.pl |   84 +++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 67 insertions(+), 17 deletions(-)

