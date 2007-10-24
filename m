Return-Path: <linux-kernel-owner+w=401wt.eu-S1758713AbXJXOH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713AbXJXOH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 10:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbXJXOHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 10:07:14 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:49056
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753197AbXJXOHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 10:07:12 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 0/9] RT: balance rt tasks v6
To: linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Darren Hart <dvhltc@us.ibm.com>
Date: Wed, 24 Oct 2007 09:52:31 -0400
Message-ID: <20071024134431.7960.41984.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Applies to 23-rt1

Changes since v5:

*) Folded some of the smaller patches together to address feedback
*) Fixed several minor bugs related to PI re-factoring and wakeup paths

I still have yet to make Ingo Oeser's suggestion to the last patch.

At this point, things are looking really really good.  So this is a request to
provide a formal review (if one has not yet been done) and to consider for
inclusion in -rt.

In my testing, cyclictest look great (ran overnight on a 4-way with the max
outlier at 32us), the preempt-test passes with flying colors, and we see a
300% improvement in latency spikes on large SMP systems (16-way is the largest
we have in our small lab).

I will rebase to -rt2 when its available.

You can find the preempt-test here:

http://rt.wiki.kernel.org/index.php/Preemption_Test

Regards,
-Greg
