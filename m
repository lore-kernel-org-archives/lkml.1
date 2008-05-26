Return-Path: <linux-kernel-owner+w=401wt.eu-S1754470AbYEZJgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbYEZJgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 05:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbYEZJgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 05:36:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36671 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072AbYEZJgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 05:36:40 -0400
Date: Mon, 26 May 2008 11:36:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Chris Wright <chrisw@sous-sol.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Top 10 bugs/warnings for the week of March 23rd, 2008
Message-ID: <20080526093609.GF13529@elte.hu>
References: <4836EE8C.1010200@linux.intel.com> <20080524001509.GG4018@sequoia.sous-sol.org> <4837A2A3.2030204@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4837A2A3.2030204@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0107]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@linux.intel.com> wrote:

>> At any rate, they have a bug in their proprietary module (news at 
>> 11).
>>
>> So, I don't think this should make the top ten.  Do you have a way to 
>> sort tainted vs non-tainted, and only produce the top ten for 
>> untainted?
>
> yes absolutely; this is a question I'll have for the customers of the 
> data... do people want to see "only-tainted" in these top 10s? Right 
> now I mark them as such but leave them in. It's trivial for me to just 
> leave them out instead (the info is there, just a matter of not 
> counting)

i think they should be included, but perhaps abbreviated [into 1-2 
lines] so that they do not hold us up.

We must not whitewash our bug statistics by intentionally excluding the 
harm that bin-only modules do to our users - but we can make them less 
visually intrusive, so that we can work on fixing the bugs we can fix.

Perhaps make sure it's top 10 of _our_ bugs, with the bin-only data 
mixed in as well (in a visually unintrusive way) to make the picture 
complete. I.e. list 20 bugs if 10 of them are bin-only modules.

	Ingo
