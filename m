Return-Path: <linux-kernel-owner+w=401wt.eu-S1758966AbXGYIpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758966AbXGYIpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 04:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750944AbXGYIpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 04:45:42 -0400
Received: from smtpq3.groni1.gr.home.nl ([213.51.130.202]:50207 "EHLO
	smtpq3.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbXGYIpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 04:45:41 -0400
Message-ID: <46A70D37.3060005@gmail.com>
Date: Wed, 25 Jul 2007 10:43:35 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Valdis.Kletnieks@vt.edu, david@lang.hm,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ray Lee <ray-lk@madrabbit.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>,
       Paul Jackson <pj@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.23
References: <46A57068.3070701@yahoo.com.au> <2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com> <46A58B49.3050508@yahoo.com.au> <2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com> <46A6CC56.6040307@yahoo.com.au> <46A6D7D2.4050708@gmail.com> <Pine.LNX.4.64.0707242211210.2229@asgard.lang.hm> <46A6DFFD.9030202@gmail.com> <30701.1185347660@turing-police.cc.vt.edu> <46A7074B.50608@gmail.com> <20070725082822.GA13098@elte.hu>
In-Reply-To: <20070725082822.GA13098@elte.hu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2007 10:28 AM, Ingo Molnar wrote:

>> Regardless, I'll stand by "[by disabling updatedb] the problem will 
>> for a large part be solved" as I expect approximately 94.372 percent 
>> of Linux desktop users couldn't care less about locate.
> 
> i think that approach is illogical: because Linux mis-handled a mixed 
> workload the answer is to ... remove a portion of that workload?

No. It got snipped but I introduced the comment by saying it was a "that's 
not the point" kind of thing. Sometimes things that aren't the point are 
still true though and in the case of Linux desktop users complaining about 
updatedb runs, a comment that says that for many an obvious solution would 
be to stop running the damned thing is not in any sense illogical.

Also note I'm not against swap prefetch or anything. I don't use it and do 
not believe I have a pressing need for it, but do suspect it has potential 
to make quite a bit of difference on some things -- if only to drastically 
reduce seeks if it means it's swapping in larger chunks than a randomly 
faulting program would.

Rene.
