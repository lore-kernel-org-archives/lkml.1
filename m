Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbZALMrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbZALMrY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 07:47:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbZALMpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 07:45:20 -0500
Received: from adelie.canonical.com ([91.189.90.139]:40869 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbZALMpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 07:45:18 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 0/6] update checkpatch to version 0.27
Date: Mon, 12 Jan 2009 12:44:58 +0000
Message-Id: <1231764304-1491-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.6.0.4.911.gc990
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This update brings an urgent fix for #if handling, and a couple of new checks.
Of note:

 - fixes spurious warning on mismatched #if/#else within the context
 - fixes to type/cast warnings on bad spacing
 - seq_operations should be const

The first patch in this series is the fix for the spurious warnings which
were affecting Ingo and probabally should be expedited to mainline.

Complete changelog below.

-apw

Andy Whitcroft (6):
  checkpatch: handle missing #if open in context
  checkpatch: type/cast spacing should not check prefix spacing
  checkpatch: allow parentheses on return handle array values
  checkpatch: if should not continue a preceeding brace
  checkpatch: struct seq_operations should normally be const
  checkpatch: version: 0.27

 scripts/checkpatch.pl |   28 ++++++++++++++++++++--------
 1 files changed, 20 insertions(+), 8 deletions(-)

