Return-Path: <linux-kernel-owner+w=401wt.eu-S1753881AbYJCMi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbYJCMi5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 08:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbYJCMie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 08:38:34 -0400
Received: from 75-130-108-43.dhcp.oxfr.ma.charter.com ([75.130.108.43]:42900
	"EHLO dev.haskins.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751297AbYJCMic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 08:38:32 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [RT PATCH 0/2] fix for BUG_ON crash in 26.5-rt9 
To: Chirag Jog <chirag@linux.vnet.ibm.com>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, dvhltc@us.ibm.com, dino@in.ibm.com,
       Gilles.Carry@bull.net
Date: Fri, 03 Oct 2008 08:42:55 -0400
Message-ID: <20081003123745.17387.61782.stgit@dev.haskins.net>
In-Reply-To: <20080925123235.GA27916@linux.vnet.ibm.com>
References: <20080925123235.GA27916@linux.vnet.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chirag,

 Please try the following patches applied to 26.5-rt9 and let me know what you
 find.

Hi Steve,
  If these look good to everyone, please consider them for inclusion in -rt10. 

Regards,
-Greg

---

Gregory Haskins (2):
      RT: remove "paranoid" limit in push_rt_task
      RT: Remove comment that is no longer true


 kernel/sched_rt.c |   15 +++------------
 1 files changed, 3 insertions(+), 12 deletions(-)

