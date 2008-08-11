Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbYHKOCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbYHKOCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 10:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbYHKOB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 10:01:57 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:32702 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbYHKOB5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 10:01:57 -0400
X-BigFish: VPS-51(z21eWz11fbM1432R98dR936eQ1805Mzzzz5a6ci2f39iz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K5FW9Z-01-B45-01
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Regression in 2.6.27-rc1 for set_cpus_allowed_ptr
Date: Mon, 11 Aug 2008 09:01:17 -0500
Message-ID: <6453C3CB8E2B3646B0D020C112613273C5AC5C@sausexmb4.amd.com>
In-Reply-To: <20080811123020.GB10082@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Regression in 2.6.27-rc1 for set_cpus_allowed_ptr
Thread-Index: Acj7rh2NI+eH1grLQeSc/mNJUaNBoAADIINQ
References: <6453C3CB8E2B3646B0D020C112613273C5AC5A@sausexmb4.amd.com> <200808082303.41068.rjw@sisk.pl> <b647ffbd0808081431q27a48113q5beee1bae7c24b0a@mail.gmail.com> <20080811123020.GB10082@elte.hu>
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: "Ingo Molnar" <mingo@elte.hu>,
       "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, "lkml" <linux-kernel@vger.kernel.org>,
       "Gautham R Shenoy" <ego@in.ibm.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
X-OriginalArrivalTime: 11 Aug 2008 14:01:17.0694 (UTC) FILETIME=[B9A1D9E0:01C8FBBA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > * Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:
> 
> > 2008/8/8 Rafael J. Wysocki <rjw@sisk.pl>:
> > > [Adding CCs]
> > 
> > 
> > if it gets called from any of the cpu-hotplug handlers, it 
> won't work
> > now (x86-microcode is another victim).
> > 
> > Please give a try to the following patch: 
> http://lkml.org/lkml/2008/7/30/171
> > 
> > does it help?
> > 
> > (the explanation is also available in this thread).
> 
> i've queued up the fix below in tip/sched/urgent.

Sorry for the delay in response - we had some building power
issues this weekend.

Yes, that fixed the issue.

-Mark Langsdorf
Operating System Research Center
AMD

