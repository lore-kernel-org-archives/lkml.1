Return-Path: <linux-kernel-owner+w=401wt.eu-S1755924AbYGBLeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbYGBLeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 07:34:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932337AbYGBLd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 07:33:28 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2922 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317AbYGBLd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 07:33:27 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 0/5] update checkpatch to version 0.21
Date: Wed,  2 Jul 2008 12:31:13 +0100
Message-Id: <1214998278-11767-1-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.5.6.1.201.g3e7d3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a pretty minor update, but some things which have been pending
for while now so it seems time to push these up.  This version brings a
few new checks and the usual fixes for false positives.  Of note:

  - add checks for question mark and colon spacing, and
  - fixes for the complex macro checks

Complete changelog below.

-apw

Andy Whitcroft (5):
  checkpatch: add checks for question mark and colon spacing
  checkpatch: variants -- move the main unary/binary operators to use
    variants
  checkpatch: complex macros need to ignore comments
  checkpatch: types cannot start mid word for pointer tests
  checkpatch: version 0.21

 scripts/checkpatch.pl |  124 +++++++++++++++++++++++++++++++++++++------------
 1 files changed, 94 insertions(+), 30 deletions(-)

