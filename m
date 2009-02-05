Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbZBEU55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbZBEU55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 15:57:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbZBEU5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 15:57:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40672 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbZBEU5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 15:57:47 -0500
Date: Thu, 5 Feb 2009 21:57:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Hugh Dickins <hugh@veritas.com>,
       William Lee Irwin III <wli@movementarian.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: pud_bad vs pud_bad
Message-ID: <20090205205735.GA21500@elte.hu>
References: <498B2EBC.60700@goop.org> <20090205184355.GF5661@elte.hu> <498B35F9.601@goop.org> <20090205191017.GF20470@elte.hu> <Pine.LNX.4.64.0902051921150.30938@blonde.anvils> <498B4F1F.5070306@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498B4F1F.5070306@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Hugh Dickins wrote:
>> However... I forget how the folding works out.  The pgd in the 32-bit
>> PAE case used to have just the pfn and the present bit set in that
>> little array of four entries: if pud_bad() ends up getting applied
>> to that, I guess it will blow up.
>>   
>
> Ah, that's a good point.
>
>> If so, my preferred answer would actually be to make those 4 entries
>> look more like real ptes; but you may think I'm being a bit silly.
>
> Hardware doesn't allow it.  It will explode (well, trap) if you set  
> anything other than P in the top level.

Yeah. I was the first Linux hacker in history to put a x86 CPU into PAE mode 
under Linux 10+ years ago, and i can attest to the 'explodes way too easily' 
aspect quite emphatically ;-) Took me 3-4 days to bootstrap it.

> By the by, what are the chances we'll be able to deprecate non-PAE 32-bit?

For the next 10 years: pretty much zero.

	Ingo
