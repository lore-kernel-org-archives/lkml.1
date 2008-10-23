Return-Path: <linux-kernel-owner+w=401wt.eu-S1755407AbYJWLHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbYJWLHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 07:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbYJWLGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 07:06:55 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:50726 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbYJWLGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 07:06:54 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 0/9] checkpatch: update to versoin 0.25
Date: Thu, 23 Oct 2008 12:06:30 +0100
Message-Id: <1224759999-21389-1-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.2.711.gf1ba4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This update brings a couple of new checks, and a number of fixes.  Of note:

 - adds checks for missuse of in_atomic(),
 - checks for spacing within stars in pointer types, and
 - fixes some comment detection corner cases.

Complete changelog below.

-apw

Andy Whitcroft (9):
  checkpatch: add checks for in_atomic()
  checkpatch: comment detection may miss an implied comment on the last
    hunk
  checkpatch: widen implied comment detection to allow multiple stars
  checkpatch: structure member assignments are not complex
  checkpatch: __weak is an official attribute
  checkpatch: detect multiple bitfield declarations
  checkpatch: comment ends inside strings is most likely not an open
    comment
  checkpatch: dissallow spaces between stars in pointer types
  checkpatch: version: 0.25

 scripts/checkpatch.pl |   92 ++++++++++++++++++++++++++++++++++---------------
 1 files changed, 64 insertions(+), 28 deletions(-)
