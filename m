Return-Path: <linux-kernel-owner+w=401wt.eu-S1761027AbZBEAYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761027AbZBEAYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 19:24:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755869AbZBEAYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 19:24:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58080 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755221AbZBEAYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 19:24:19 -0500
Date: Thu, 5 Feb 2009 01:24:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: mm: introduce helper function in fault.c
Message-ID: <20090205002402.GF15680@elte.hu>
References: <498A2399.4090503@ct.jp.nec.com> <498A2FAF.60503@zytor.com> <20090205001945.GE15680@elte.hu> <498A3110.2020208@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498A3110.2020208@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> Ingo Molnar wrote:
>> * H. Peter Anvin <hpa@zytor.com> wrote:
>>
>>> Hiroshi Shimamoto wrote:
>>>> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>>>>
>>>> Impact: cleanup
>>>>
>>>> Introduce helper function fault_in_kernel_address() to make editors happy.
>>>>
>>>> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>>> Applied to tip:x86/mm, however, I had to apply the patch manually.
>>
>> that's because the patch was against tip:master - so that's fine, we 
>> have some other topics that interact. (tip:core/locking in this case) I 
>> resolved the conflict in tip/master and pushed it out.
>>
>
> Of course.  I mentioned it just as a warning for screwups on my part (in  
> fact, I briefly pushed a totally bogus version since I had made an edit  
> but forgotten to "git add" it.)

ok :) Hiroshi, please double-check the end result in tip:master if you have 
some time.

	Ingo
