Return-Path: <linux-kernel-owner+w=401wt.eu-S1751628AbYIFFJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628AbYIFFJf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 01:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751537AbYIFFJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 01:09:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:48093 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbYIFFJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 01:09:08 -0400
Message-Id: <20080906050602.409299112@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 06 Sep 2008 01:06:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org
Subject: [PATCH 0/2] ftrace: fixes for PPC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I spent the day chasing a bug that would hang PPC on boot up when ftrace
is configured in. I found that it was simply a stupid bug I did to
handle the non MCOUNT_RECORD case. Since I was testing only on x86,
and the MCOUNT_RECORD is automatically set for dynamic ftrace if
it is available, I did not test the case where MCOUNT_RECORD was not
set.

I have not finished porting MCOUNT_RECORD to PPC, but have found
that it has caused some issues for archs that do not support it yet.

This patch series handles these cases.

-- Steve

