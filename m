Return-Path: <linux-kernel-owner+w=401wt.eu-S1760779AbXJMA3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760779AbXJMA3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 20:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757501AbXJMA3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 20:29:00 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:33462
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751983AbXJMA27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 20:28:59 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 0/7] RT: RT-Overload/Sched enhancements (v2)
To: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Gregory Haskins <ghaskins@novell.com>
Date: Fri, 12 Oct 2007 20:15:33 -0400
Message-ID: <20071013001052.7444.8363.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This series applies to 2.6.23-rt1 + Steven Rostedt's last published "push-rt"
patch.

Changes since v1:

- Rebased to the final 23-rt1 from 23-rt1-pre1
- Rebased to Steve's last published patch
- Removed controversial "cpupri" algorithm (may revisit later, drop for now)
- Fixed a missing priority update in the set_user_nice() code
- Added experimental "phase 3" patch for limiting pulls to when necessary

Comments/suggestions/feedback are all welcome.

Regards,
-Greg 
