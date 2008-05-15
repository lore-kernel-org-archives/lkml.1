Return-Path: <linux-kernel-owner+w=401wt.eu-S1763002AbYEOSfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763002AbYEOSfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbYEOSfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:35:32 -0400
Received: from nds154-200.nds.lab.novell.com ([151.155.154.200]:54146 "EHLO
	lsg.lab.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751874AbYEOSfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:35:32 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [RFC PATCH 0/3] sched: core-balancer v2
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Suresh Sidda <suresh.b.siddha@intel.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Gregory Haskins <ghaskins@novell.com>
Date: Thu, 15 May 2008 12:35:30 -0600
Message-ID: <20080515182832.5323.70102.stgit@lsg>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is an update to the core-balancer previously discussed here

http://lkml.org/lkml/2008/5/12/260

Changes since v1:

1) Fixed a memory allocation error pointed out by Suresh Siddha
2) Implemented a suggestion by Suresh to only assign core-balancers to SMP or
NUMA domains (i.e. exclude HT/MC domains)
3) Fixed several small bugs and misc cleanups

Comments/feedback welcome!

Regards,
-Greg
