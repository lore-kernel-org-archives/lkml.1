Return-Path: <linux-kernel-owner+w=401wt.eu-S1754680AbYJFPKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbYJFPKV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 11:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbYJFPKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 11:10:11 -0400
Received: from 75-130-108-43.dhcp.oxfr.ma.charter.com ([75.130.108.43]:45710
	"EHLO dev.haskins.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751449AbYJFPKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 11:10:09 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [RT PATCH v3 0/2] Fix for "[BUG][PPC64] BUG in 2.6.26.5-rt9 causing
	Hang"
To: Chirag Jog <chirag@linux.vnet.ibm.com>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, dvhltc@us.ibm.com, dino@in.ibm.com,
       Gilles.Carry@bull.net
Date: Mon, 06 Oct 2008 11:14:32 -0400
Message-ID: <20081006151228.8452.69938.stgit@dev.haskins.net>
In-Reply-To: <20080925123235.GA27916@linux.vnet.ibm.com>
References: <20080925123235.GA27916@linux.vnet.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,
  Chirag reported (via IRC) that v2 fixed his issue.  V3 is identical to v2
  except I cleaned up the patch description and fixed a comment typo.  This
  applies to 26.5-rt9.  Please consider it an urgent fix for -rt10.

Regards,
-Greg

---

Gregory Haskins (2):
      RT: fix push_rt_task() to handle dequeue_pushable properly
      RT: Remove comment that is no longer true


 kernel/sched_rt.c |   44 ++++++++++++++++++++++----------------------
 1 files changed, 22 insertions(+), 22 deletions(-)

-- 

