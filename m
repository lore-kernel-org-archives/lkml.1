Return-Path: <linux-kernel-owner+w=401wt.eu-S1762767AbYHFBZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762767AbYHFBZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 21:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbYHFBY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 21:24:59 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34253 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769AbYHFBY6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 21:24:58 -0400
From: "Woodruff, Richard" <r-woodruff2@ti.com>
To: "Wei, Gang" <gang.wei@intel.com>,
       Linux Power Management List <linux-pm@lists.osdl.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 5 Aug 2008 20:24:44 -0500
Subject: RE: [linux-pm] [RFC-PATCH] Improve Menu Governor Prediction of
 interrupted C states.
Thread-Topic: [linux-pm] [RFC-PATCH] Improve Menu Governor Prediction of
 interrupted C states.
Thread-Index: Acjl9NwKQ0on4gDvSK+0rYSuOpnIRwFzHyfwAuhi8pA=
Message-ID: <13B9B4C6EF24D648824FF11BE89671620361F4E439@dlee02.ent.ti.com>
References: <13B9B4C6EF24D648824FF11BE8967162035BEA0EDF@dlee02.ent.ti.com>
 <094BCE01AFBE9646AF220B0B3F367AAB034DBB7A@pdsmsx413.ccr.corp.intel.com>
In-Reply-To: <094BCE01AFBE9646AF220B0B3F367AAB034DBB7A@pdsmsx413.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> I also found current cpuidle Menu governor should have some problems
> while predicting next non-expected break-event after some expected
> break-events. The measured_us/elapsed_us/predicted_us will become
> larger
> and larger once (measured_us + BREAK_FUZZ >= data->expected_us -
> target->exit_latency). The major point is that it should be
> last_residency, not measured_us, that need to be used to do comparing
> and distinguish between expected & non-expected events.
>
> Below is my draft patch (not tested) for this. It is simple and should
> also be effective for high interrupt rates case.

This does seem to give better guesses.  However, first tests are not showing as well as the irq time stamp version I posted.

I'll need to grab some hardware trace to see what is going on.

Thanks,
Richard W.

