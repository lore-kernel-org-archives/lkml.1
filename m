Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbYIBRZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbYIBRZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 13:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbYIBRZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 13:25:20 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:36120 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbYIBRZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 13:25:18 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 0/7] checkpatch: update to version 0.23
Date: Tue,  2 Sep 2008 18:25:07 +0100
Message-Id: <1220376314-15180-1-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.rc1.258.g80295
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This update brings a few small fixes to existing checks.  Of note:

 - restricts case/default checks to changed lines,
 - suppresses perl errors for short patch hunks
 - fixes comment handling for long hunks

Complete changelog below.

-apw

Andy Whitcroft (7):
  checkpatch: case/default checks should only check changed lines
  checkpatch: suppress errors triggered by short patch
  checkpatch: handle comment/quote nesting correctly
  checkpatch: check line endings in text format files
  checkpatch: suspect indent count condition lines correctly
  checkpatch: ensure we only apply checks to the lines within hunks
  checkpatch: version: 0.23

 scripts/checkpatch.pl |   37 +++++++++++++++++++++----------------
 1 files changed, 21 insertions(+), 16 deletions(-)

