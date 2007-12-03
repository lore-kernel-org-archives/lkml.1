Return-Path: <linux-kernel-owner+w=401wt.eu-S1753026AbXLCREk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbXLCREk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 12:04:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091AbXLCREd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 12:04:33 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:2714 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbXLCREd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 12:04:33 -0500
From: "David Schwartz" <davids@webmaster.com>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>, "Ingo Molnar" <mingo@elte.hu>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>
Subject: RE: sched_yield: delete sysctl_sched_compat_yield
Date: Mon, 3 Dec 2007 09:04:04 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKOEGJIJAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <20071203113716.GA8432@elte.hu>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Mon, 03 Dec 2007 09:05:11 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Mon, 03 Dec 2007 09:05:12 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


	I've asked versions of this question at least three times and never gotten
anything approaching a straight answer:

	1) What is the current default 'sched_yield' behavior?

	2) What is the current alternate 'sched_yield' behavior?

	3) Are either of them sensible? Simply acting as if the current thread's
timeslice was up should be sufficient.

	The implication I keep getting is that neither the default behavior nor the
alternate behavior are sensible. What is so hard about simply scheduling the
next thread?

	We don't need perfection, but it sounds like we have two alternatives of
which neither is sensible.

	DS


