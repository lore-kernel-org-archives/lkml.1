Return-Path: <linux-kernel-owner+w=401wt.eu-S934066AbXDFR7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934066AbXDFR7J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 13:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934085AbXDFR7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 13:59:09 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:47925 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934066AbXDFR7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 13:59:08 -0400
Date: Fri, 6 Apr 2007 19:41:47 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Hugh Dickins <hugh@veritas.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, Eric Dumazet <dada1@cosmosbay.com>,
       Ulrich Drepper <drepper@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Ravikiran G Thirumalai <kiran@scalex86.org>,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>,
       pravin b shelar <pravin.shelar@calsoftinc.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FUTEX : new PRIVATE futexes
In-Reply-To: <Pine.LNX.4.64.0704060644150.4723@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.61.0704061941220.6042@yvahk01.tjqt.qr>
References: <20060808070708.GA3931@localhost.localdomain>
 <200608090826.28249.dada1@cosmosbay.com> <200608090843.52893.dada1@cosmosbay.com>
 <200703152010.35614.dada1@cosmosbay.com> <a36005b50704040016l180f397bwe5a05e8bf78013b0@mail.gmail.com>
 <20070405194942.1414c030.dada1@cosmosbay.com> <4615A009.808@yahoo.com.au>
 <Pine.LNX.4.64.0704060644150.4723@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 6 2007 07:05, Hugh Dickins wrote:
>On Fri, 6 Apr 2007, Nick Piggin wrote:
>> 
>> I like |= for adding flags, it seems less ambiguous. But I guess that's
>> a matter of opinion. Hugh seems to like +=,
>
>Do I?  You probably have a shaming example in mind (PAGE_MAPPING_ANON?
>that's a hybrid case where using + and - helped minimize the casting);
>but in general I'd agree with you that it's |= for setting flag bits.
>
>Hmm, Eric's FUT_OFF_INODE is hybrid too, that might justify the +=

If a bit is already set, you can't set it again using +=.


Jan
-- 
