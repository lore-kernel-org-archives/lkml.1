Return-Path: <linux-kernel-owner+w=401wt.eu-S1760820AbZANJ3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760820AbZANJ3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 04:29:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754820AbZANJ2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 04:28:53 -0500
Received: from mga10.intel.com ([192.55.52.92]:41788 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753188AbZANJ2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 04:28:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,262,1231142400"; 
   d="scan'208";a="656993163"
Message-ID: <496DB067.6060402@linux.intel.com>
Date: Wed, 14 Jan 2009 10:29:11 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Tim Hockin <thockin@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       ying.huang@intel.com, Aaron Durbin <adurbin@gmail.com>,
       priyankag@google.com
Subject: Re: x86/mce merge, integration hickup + crash, design thoughts
References: <20081227155019.GA15493@elte.hu> <20081227225102.GA17822@elte.hu>	 <49594411.60000@linux.intel.com> <20090113174522.GA26965@elte.hu> <b3ece790901131057w4c76a428p4308b494675d69aa@mail.gmail.com>
In-Reply-To: <b3ece790901131057w4c76a428p4308b494675d69aa@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> I'm 100% on board with that and will even help staff the effort. 

Well if you want to change anything the code would be a good idea first to
establish clearly what is actually broken. I know various areas that need
improvement (and I have patches fixes most of them), but to my knowledge
none of them would be fixed by ASCII logging.

Perhaps a good start would be if Ingo could expand what exactly
he believes is broken currently. At least his earlier "high level" argument
seems to be large  based on clear misunderstandings of what kind
of MCE events are common and what not. I don't really blame
him for that since MCEs are obscure and difficult and badly
documented (I had a hard time getting up to speed on them myself
and it took me quite some time). But I hope he doesn't
dismiss the advice from people who have more experience with
them than him though.

I wrote a long email earlier in the thread with all the reasons why
ASCII logging is difficult (like the various atomicity issues and also others)
I haven't heard anyone refuting any of the arguments in there, so I assume they
are agreed one by everyone.

I would appreciate if the people who continue to propose ASCII
logging would explain how they plan to solve these problems.

> This
> is something that is VERY HIGHLY desired here.  

What is exactly desired?

> I already have a
> couple peopel looking at this and other HW-error reporting issues.

I have lots of patches pending for over half a year (including
tons of bug fixes) and they get all delayed again and again with
very little justification why. So before writing any new code
it would be good to just get the already pending improvements in.

-Andi


