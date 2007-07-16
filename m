Return-Path: <linux-kernel-owner+w=401wt.eu-S1760816AbXGPTq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760816AbXGPTq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 15:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753731AbXGPTqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 15:46:49 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:38845 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbXGPTqs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 15:46:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ncxbTaPPKiyxj4Ktb0Sk0A7XRVGDinuf/wnEaa99bX3TXugP9g9DmpjN2UCTrFJvicuMuZ7IIoPH2Bo9F5eQVp+Pb6ncSyp43r06OP6mgTOMSXP7ROOwF8ydRoTimqL8WitGAUU4Ij8kfouDKHgafU9qh9UrviIMWCCeUFLIPaI=
Message-ID: <3efb10970707161246se06ab22i32872cfe6fa4f2f6@mail.gmail.com>
Date: Mon, 16 Jul 2007 21:46:46 +0200
From: "Remy Bohmer" <l.pinguin@gmail.com>
Reply-To: linux@bohmer.net
To: LKML <linux-kernel@vger.kernel.org>,
       RT-Users <linux-rt-users@vger.kernel.org>
Subject: [Question] Hooks for scheduler tracing (CFS)
Cc: mathieu.desnoyers@polymtl.ca, "Ingo Molnar" <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am looking for some tool/kernel machanism that enables me to track
every schedule change on the CFS scheduler of the RT-kernel for some
period of time.
Thus a tool that gives me an overview after some time which task got
"scheduled in/out" at "which timestamp" and at "which CPU". ( I need
the raw data)

In a far past (on Montavista kernels) I used LTT for this to log for
some time with only the SCHED_CHANGE filter and text output. But, I
cannot find any LTT(ng) support for any RT-kernel, and support for the
new CFS (like in 2.6.22.1-rt4) is even harder.

So I was wondering if anybody knows some tool/kernel mechanism which
can do this?
If not, I will build a kernel extension for it myself (new extension
to 'latency_trace' ?)
In that case can anybody with in depth CFS scheduler knowledge please
point me which hooks are safe to use for this?

I need it to get a detailed insight in my RT-system with its RT and
non-RT applications.
Thus to know when a certain task gets scheduled (and to calculate its
per thread min/max/avg latencies), which task preempts another task,
and to get a complete overview of what the RT system (and scheduler)
is doing during time etc.


Kind Regards,

Remy Böhmer
