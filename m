Return-Path: <linux-kernel-owner+w=401wt.eu-S1756335AbZA3PGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335AbZA3PGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 10:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbZA3PFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 10:05:33 -0500
Received: from adelie.canonical.com ([91.189.90.139]:60150 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbZA3PFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 10:05:31 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 0/8] update checkpatch to v0.28
Date: Fri, 30 Jan 2009 15:05:12 +0000
Message-Id: <1233327920-16691-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.6.1.2.419.g0d87e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the next batch of updates for checkpatch.  These have passed
testing here, I have some more stuff you sent me pending and will get
you another update out next week hopefully with those.

This update brings an a number of fixes mostly relating to the handling
of modifiers.  Of note:

 - multiple modifier handling fixes, and
 - do not warn about -p0 patches when using --file

Complete changelog below.

-apw

Andy Whitcroft (8):
  checkpatch: make in_atomic ok in the core
  checkpatch: do not warn about -p0 patches when checking files
  checkpatch: correctly handle type spacing in the face of modifiers
  checkpatch: pointer type star may have modifiers following
  checkpatch: a modifier is not an identifier at the end of a type
  checkpatch: extend attribute testing to all modifiers
  checkpatch: add __ref as a sparse modifier
  checkpatch: version 0.28

 scripts/checkpatch.pl |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

