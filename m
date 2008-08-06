Return-Path: <linux-kernel-owner+w=401wt.eu-S1761998AbYHFBwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761998AbYHFBwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 21:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760012AbYHFBvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 21:51:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:29578 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759031AbYHFBvc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 21:51:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,314,1215414000"; 
   d="scan'208";a="426374744"
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [linux-pm] [RFC-PATCH] Improve Menu Governor Prediction of interrupted C states.
Date: Wed, 6 Aug 2008 09:51:14 +0800
Message-ID: <094BCE01AFBE9646AF220B0B3F367AAB035B08D0@pdsmsx413.ccr.corp.intel.com>
In-Reply-To: <13B9B4C6EF24D648824FF11BE89671620361F4E439@dlee02.ent.ti.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [linux-pm] [RFC-PATCH] Improve Menu Governor Prediction of interrupted C states.
Thread-Index: Acjl9NwKQ0on4gDvSK+0rYSuOpnIRwFzHyfwAuhi8pAAALobgA==
References: <13B9B4C6EF24D648824FF11BE8967162035BEA0EDF@dlee02.ent.ti.com> <094BCE01AFBE9646AF220B0B3F367AAB034DBB7A@pdsmsx413.ccr.corp.intel.com> <13B9B4C6EF24D648824FF11BE89671620361F4E439@dlee02.ent.ti.com>
From: "Wei, Gang" <gang.wei@intel.com>
To: "Woodruff, Richard" <r-woodruff2@ti.com>,
       "Linux Power Management List" <linux-pm@lists.osdl.org>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 06 Aug 2008 01:51:16.0358 (UTC) FILETIME=[E9EFA260:01C8F766]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
> 
>> I also found current cpuidle Menu governor should have some problems
>> while predicting next non-expected break-event after some expected
>> break-events. The measured_us/elapsed_us/predicted_us will become
larger
>> and larger once (measured_us + BREAK_FUZZ >= data->expected_us -
>> target->exit_latency). The major point is that it should be
>> last_residency, not measured_us, that need to be used to do comparing
>> and distinguish between expected & non-expected events.
>> 
>> Below is my draft patch (not tested) for this. It is simple and
should
>> also be effective for high interrupt rates case.
> 
> This does seem to give better guesses.  However, first tests are not
showing
> as well as the irq time stamp version I posted. 
> 
> I'll need to grab some hardware trace to see what is going on.

Thanks for the trial. My original patch has already been merged into
another patch "[patch 2/3] cpuidle: Menu governor fix wrong usage of
measured_us" sent out by Venkatesh. The new patch should be more intact.

Jimmy
