Return-Path: <linux-kernel-owner+w=401wt.eu-S932806AbZHUVqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932806AbZHUVqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932234AbZHUVqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:46:18 -0400
Received: from adelie.canonical.com ([91.189.90.139]:59321 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224AbZHUVqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:46:18 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 0/7] update checkpatch to v0.29
Date: Fri, 21 Aug 2009 22:46:03 +0100
Message-Id: <1250891170-8599-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a few update for checkpatch that seem to have gotten lost
somewhere along the line, I though you had everything I had queued.
These have passed testing here, I have some more stuff in testing and I
will get those out soon.

This update brings an a number of minor fixes.  Thanks for the
contributions.

Complete changelog below.

-apw

Andy Whitcroft (5):
  checkpatch: possible types -- else cannot start a type
  checkpatch: indent checks -- stop when we run out of continuation
    lines
  checkpatch: format strings should not have brackets in macros
  checkpatch: limit sN/uN matches to actual bit sizes
  checkpatch: version 0.29

Daniel Walker (1):
  checkpatch: handle C99 comments correctly (performance issue)

Hannes Eder (1):
  checkpatch: make -f alias --file, add --help, more verbose help
    message

 scripts/checkpatch.pl |   84 ++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 65 insertions(+), 19 deletions(-)

