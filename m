Return-Path: <linux-kernel-owner+w=401wt.eu-S1757129AbYG2Xru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129AbYG2Xru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 19:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753638AbYG2Xrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 19:47:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47243 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641AbYG2Xrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 19:47:40 -0400
Message-ID: <488FAB2B.7050405@zytor.com>
Date: Tue, 29 Jul 2008 16:43:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "drepper@redhat.com" <drepper@redhat.com>,
       "mikpe@it.uu.se" <mikpe@it.uu.se>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/9] x86, xsave: xsave/xrstor support
References: <20080729172917.185593000@linux-os.sc.intel.com> <488FA318.3040905@zytor.com> <20080729232951.GB11223@linux-os.sc.intel.com>
In-Reply-To: <20080729232951.GB11223@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> On Tue, Jul 29, 2008 at 04:09:12PM -0700, H. Peter Anvin wrote:
>> Applied as tip:x86/xsave.
>>
>> I should warn I had to do quite a bit of manual fixup in order to
>> disentangle it from other changes in -tip, so please test it out; I
>> compile-tested it but for obvious reasons can't do more than that at the
>> moment.
> 
> hpa, these patches just apply fine to tip/master. Can you please arrange
> the tip/x86/xsave tree accordingly? or do I need to do something else
> to smooth this process?

This is awkward, since that means this is "derived topic".  Most of the 
changes are orthogonal and relatively trivial to fix up at merge time, 
so I would prefer to keep them separate.

	-hpa
