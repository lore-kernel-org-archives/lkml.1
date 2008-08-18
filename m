Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbYHRQ3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbYHRQ3h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 12:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbYHRQ3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 12:29:30 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:14187 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751502AbYHRQ33 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 12:29:29 -0400
X-BigFish: VPS-37(z21eWz1432R936eQ1805Mzzzz2f39iz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K5T1SJ-02-2LM-01
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Warning in during hotplug on 2.6.27-rc2-git5
Date: Mon, 18 Aug 2008 11:29:15 -0500
Message-ID: <6453C3CB8E2B3646B0D020C112613273C5AC7D@sausexmb4.amd.com>
In-Reply-To: <200808181638.37707.rjw@sisk.pl>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Warning in during hotplug on 2.6.27-rc2-git5
Thread-Index: AckBP7R8eMwIT6WYQZKrttYeCPI52QAD7Bkw
References: <200808141753.58547.rjw@sisk.pl> <200808172353.54479.rjw@sisk.pl> <6453C3CB8E2B3646B0D020C112613273C5AC7B@sausexmb4.amd.com> <200808181638.37707.rjw@sisk.pl>
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "Andi Kleen" <andi@firstfloor.org>, <linux-kernel@vger.kernel.org>,
       "Greg KH" <greg@kroah.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>
X-OriginalArrivalTime: 18 Aug 2008 16:29:17.0232 (UTC) FILETIME=[8F241300:01C9014F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > I'm still seeing it on 2.6.27-rc2, even with the 
> > > > patch here http://lkml.org/lkml/2008/7/30/171 and the
> > > > wbinvd_halt code patch applied.  Maybe something else
> > > > broke in some of the recent hotplug changes?
>
> I have a couple of questions, then:
> - Does it fail identically for all CPUs or for CPU4 and above only?
> - Did previous kernels, most importantly 2.6.26, work correctly?

It turns out 2.6.26 also fails.  It is only failing for CPU4+,
I'm not sure why that would be significant.

> Also, can you please attach dmesg output, including the 
> offlining of a CPU that would later lead to the problem
> with cpu_up(), to the Bugzilla entry at
> http://bugzilla.kernel.org/show_bug.cgi?id=11337 ?

I did.

-Mark Langsdorf
Operating System Research Center
AMD

