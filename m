Return-Path: <linux-kernel-owner+w=401wt.eu-S1752463AbZJPSjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbZJPSjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 14:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbZJPSjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 14:39:44 -0400
Received: from adelie.canonical.com ([91.189.90.139]:52939 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbZJPSjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 14:39:44 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 0/7] update checkpatch to v0.30
Date: Fri, 16 Oct 2009 19:39:25 +0100
Message-Id: <1255718372-22805-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a batch of checkpatch updates.  The second of which should fix
akpm's issue triggering perl warnings on some patches.  The rest are the
normal slew of little fixes.  These have passed testing here.

Complete changelog below.

-apw

Andy Whitcroft (7):
  checkpatch: possible types -- prevent illegal modifiers being added
  checkpatch: correctly stop scanning at the bottom of a hunk
  checkpatch: update copyright dates
  checkpatch: fix false errors due to macro concatenation
  checkpatch: fix __attribute__ matching
  checkpatch: fix false EXPORT_SYMBOL warning
  checkpatch: version 0.30

 scripts/checkpatch.pl |   84 +++++++++++++++++++++++++++++++++++-------------
 1 files changed, 61 insertions(+), 23 deletions(-)

