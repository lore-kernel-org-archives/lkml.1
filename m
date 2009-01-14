Return-Path: <linux-kernel-owner+w=401wt.eu-S1757189AbZANOn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189AbZANOn0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 09:43:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbZANOnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 09:43:16 -0500
Received: from 68-112-229-48.dhcp.oxfr.ma.charter.com ([68.112.229.48]:60275
	"EHLO dev.haskins.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751914AbZANOnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 09:43:16 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH v3 0/2] fixes for tip/sched/rt
To: mingo@elte.hu
Cc: rostedt@home.goodmis.org, peterz@infradead.org, ghaskins@novell.com,
       linux-kernel@vger.kernel.org
Date: Wed, 14 Jan 2009 09:46:19 -0500
Message-ID: <20090114144317.11627.69111.stgit@dev.haskins.net>
In-Reply-To: <496DE6E4.1010209@novell.com>
References: <496DE6E4.1010209@novell.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here is the latest iteration of the patch.  V3 is identical to v2 except
I converted all the CPP violations to static-inlines.  I also included
a new patch (1/2) to fix a previous CPP macro that I introduced to the tree.

I verified that this builds for both SMP and UP.

As before, you can also find these patches in my git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/ghaskins/linux-2.6-hacks.git sched/latest

-Greg

---

Gregory Haskins (2):
      sched: fix build error in kernel/sched_rt.c when RT_GROUP_SCHED && !SMP
      sched: de CPP-ify the scheduler code


 kernel/sched.c    |    4 +
 kernel/sched_rt.c |  270 ++++++++++++++++++++++++++++++++++-------------------
 2 files changed, 178 insertions(+), 96 deletions(-)


