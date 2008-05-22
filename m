Return-Path: <linux-kernel-owner+w=401wt.eu-S1755682AbYEVUTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682AbYEVUTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 16:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757264AbYEVUS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 16:18:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:37248 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756927AbYEVUSv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 16:18:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,526,1204531200"; 
   d="scan'208";a="331347865"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: fair group scheduler not so fair?
Date: Thu, 22 May 2008 13:18:33 -0700
Message-ID: <5FD5754DDBA0B1499B5A0B4BB54194850357ED61@fmsmsx411.amr.corp.intel.com>
In-Reply-To: <1211486868.6463.134.camel@lappy.programming.kicks-ass.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: fair group scheduler not so fair?
thread-index: Aci8SC27kjmthjtiTTiBAmRXsgeE8wAAFbQQ
References: <4834B75A.40900@nortel.com> <1211439417.29104.7.camel@twins> <4835D14B.20904@nortel.com> <1211486868.6463.134.camel@lappy.programming.kicks-ass.net>
From: "Li, Tong N" <tong.n.li@intel.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Chris Friesen" <cfriesen@nortel.com>
Cc: <linux-kernel@vger.kernel.org>, <vatsa@linux.vnet.ibm.com>,
       <mingo@elte.hu>, <pj@sgi.com>
X-OriginalArrivalTime: 22 May 2008 20:18:50.0416 (UTC) FILETIME=[0C3F2B00:01C8BC49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

I didn't look at your patches, but I thought you were flattening group
weights down to task-level so that the scheduler only looks at per-task
weights. That'd make group fairness as good as task fairness gets. Is
this still the case?

  tong

>-----Original Message-----
>From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
>owner@vger.kernel.org] On Behalf Of Peter Zijlstra
>Sent: Thursday, May 22, 2008 1:08 PM
>To: Chris Friesen
>Cc: linux-kernel@vger.kernel.org; vatsa@linux.vnet.ibm.com;
mingo@elte.hu;
>pj@sgi.com
>Subject: Re: fair group scheduler not so fair?
>
>On Thu, 2008-05-22 at 14:02 -0600, Chris Friesen wrote:
>
>> I haven't really dug into the scheduler yet (although that's next),
but
>> based on these results it doesn't really look like the load balancer
is
>> properly group-aware.
>
>I'm trying, but its turning out to be rather more difficult than
>expected. Any help here would be much appreciated.
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel"
in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
