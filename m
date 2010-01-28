Return-Path: <linux-kernel-owner+w=401wt.eu-S1754053Ab0A1Mlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab0A1Mlj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 07:41:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421Ab0A1Mli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 07:41:38 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:15033 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab0A1Mlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 07:41:37 -0500
Date: Thu, 28 Jan 2010 13:40:25 +0100
From: Tomasz Fujak <t.fujak@samsung.com>
Subject: RE: [PATCH/RFC v2 0/3] Human readable platform-specific performance
 event support
In-reply-to: <1264680815.4283.2100.camel@laptop>
To: "'Peter Zijlstra'" <peterz@infradead.org>
Cc: jpihet@mvista.com, Michal Nazarewicz <m.nazarewicz@samsung.com>,
       Pawel Osciak <p.osciak@samsung.com>, jamie.iles@picochip.com,
       will.deacon@arm.com, linux-kernel@vger.kernel.org, acme@redhat.com,
       kyungmin.park@samsung.com, mingo@elte.hu,
       linux-arm-kernel@lists.infradead.org,
       Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <000201caa017$104aa5e0$30dff1a0$%fujak@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: AcqgE4UETudlZVJVTsanY77/2PiqkAAAGCYA
References: <1264671263-21412-1-git-send-email-t.fujak@samsung.com>
 <1264675934.4283.2088.camel@laptop>
 <000101caa011$1ba9ee10$52fdca30$%fujak@samsung.com>
 <1264680815.4283.2100.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, I missed your statement from yesterday, that's why I posted the same
idea :s

Otherwise if the perf is meant to be closely tied to the kernel, maybe we
could use a (semi-)automated process to transform the event definitions 
(enums in a .c file) to something perf could use. Basically a replacement
for sysfs/debugfs entry in a separately distributed file.

But that does not look so straightforward to implement to me, maybe I'll
come up with something next week.

> -----Original Message-----
> From: linux-arm-kernel-bounces@lists.infradead.org [mailto:linux-arm-
> kernel-bounces@lists.infradead.org] On Behalf Of Peter Zijlstra
> Sent: Thursday, January 28, 2010 1:14 PM
> To: Tomasz Fujak
> Cc: jpihet@mvista.com; Michal Nazarewicz; Pawel Osciak;
> jamie.iles@picochip.com; will.deacon@arm.com; linux-
> kernel@vger.kernel.org; acme@redhat.com; kyungmin.park@samsung.com;
> mingo@elte.hu; linux-arm-kernel@lists.infradead.org; Marek Szyprowski
> Subject: RE: [PATCH/RFC v2 0/3] Human readable platform-specific
> performance event support
> 
> On Thu, 2010-01-28 at 12:57 +0100, Tomasz Fujak wrote:
> 
> please educate your MUA to wrap lines at ~80.
> 
> > Apparently I did not comprehend your attitude towards the events'
> > description being exported from the kernel.
> > There's been a lengthy discussion which ended in a conclusion that
> the
> > platform detection is a complicated task.
> 
> If its really that complicated export a pmu identifier someplace.
> 
> The fact is, the kernel simply doesn't use this list, we have perf in
> kernel so that resource scheduling and isolation can be done, for that
> we need to know how to program the hardware and we need to know about
> scheduling constraints, we do not need exhaustive lists of possible
> events, let alone descriptive text for them, in the kernel.
> 
> 
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

