Return-Path: <linux-kernel-owner+w=401wt.eu-S1753080AbYHRGy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbYHRGy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 02:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbYHRGyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 02:54:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:31279 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbYHRGyt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 02:54:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,226,1217833200"; 
   d="scan'208";a="34688884"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: scale sysctl_sched_shares_ratelimit with nr_cpus
Date: Mon, 18 Aug 2008 14:54:45 +0800
Message-ID: <37E52D09333DE2469A03574C88DBF40F024EBD69@pdsmsx414.ccr.corp.intel.com>
In-Reply-To: <20080818065220.GA2711@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: scale sysctl_sched_shares_ratelimit with nr_cpus
Thread-Index: AckA/wEU4k4j6iJ4TdaM4jkCGMNdnAAAA4VQ
References: <37E52D09333DE2469A03574C88DBF40F024EBD2F@pdsmsx414.ccr.corp.intel.com> <20080818065220.GA2711@elte.hu>
From: "Zhang, Yanmin" <yanmin.zhang@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <a.p.zijlstra@chello.nl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 18 Aug 2008 06:54:47.0702 (UTC) FILETIME=[4DB33360:01C900FF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>-----Original Message-----
>>From: Ingo Molnar [mailto:mingo@elte.hu]
>>Sent: Monday, August 18, 2008 2:52 PM
>>To: Zhang, Yanmin
>>Cc: a.p.zijlstra@chello.nl; Linux Kernel Mailing List
>>Subject: Re: scale sysctl_sched_shares_ratelimit with nr_cpus
>>
>>
>>* Zhang, Yanmin <yanmin.zhang@intel.com> wrote:
>>
>>> Ingo,
>>>
>>> My linux mailbox is locked, so I send from my another mail box.
>>>
>>> I tested the patch of scale sysctl_sched_shares_ratelimit with
nr_cpus
>>> on 16-core tigerton by volanoMark. CONFIG_GROUP_SCHED=y. Comparing
>>> with pure 2.6.27-rc3, the patched kernel has about 15% improvement,
>>> and it seems volanoMark runs more smoothly with the patched kernel.
>>
>>cool. It's already upstream (post-rc3 commit):
[YM] But comparing with 2.6.26, volanoMark result still has about 60%
regression.

>>
>>  55cd534: sched: scale sysctl_sched_shares_ratelimit with nr_cpus
>>
>>	Ingo
