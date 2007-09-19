Return-Path: <linux-kernel-owner+w=401wt.eu-S1758921AbXISW5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921AbXISW5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 18:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbXISW5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 18:57:06 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:2298 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbXISW5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 18:57:05 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <CFRIESEN@nortel.com>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: CFS: some bad numbers with Java/database threading [FIXED]
Date: Wed, 19 Sep 2007 15:56:32 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKEELFGOAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
In-Reply-To: <46F17D03.9090801@nortel.com>
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Wed, 19 Sep 2007 15:56:08 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Wed, 19 Sep 2007 15:56:10 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> David Schwartz wrote:

> > Nonsense. The task is always ready-to-run. There is no reason
> > its CPU should
> > be low. This bug report is based on a misunderstanding of what yielding
> > means.

> The yielding task has given up the cpu.  The other task should get to
> run for a timeslice (or whatever the equivalent is in CFS) until the
> yielding task again "becomes head of the thread list".

Are you sure this isn't happening? I'll run some tests on my SMP system
running CFS. But I'll bet the context switch rate is quite rapid.

Honestly, I can't imagine what else could be happening here. Does CFS spin
in a loop doing nothing when you call sched_yield even though another task
is ready-to-run? That seems kind of bizarre. Is sched_yield acting as a
no-op?

DS


