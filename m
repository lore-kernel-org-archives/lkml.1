Return-Path: <linux-kernel-owner+w=401wt.eu-S1754307AbYG3Sc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307AbYG3Sc5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 14:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbYG3Sct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 14:32:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53102 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296AbYG3Scs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 14:32:48 -0400
Date: Wed, 30 Jul 2008 20:32:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Jeff Dike <jdike@addtoit.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86: use arch/x86/include
Message-ID: <20080730183201.GA26389@elte.hu>
References: <20080730124952.GA23413@uranus.ravnborg.org> <20080730180411.GA7896@elte.hu> <4890B153.6050305@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4890B153.6050305@zytor.com>
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
>> * Sam Ravnborg <sam@ravnborg.org> wrote:
>>
>>> Hi x86 guys.
>>>
>>> It turned out to be easy to enable um to use arch/x86/include so here 
>>> is a git pull.
>>
>> hm, we have a _ton_ of changes to include files queued up already, so  
>> this is rather inconvenient.
>
> Git *should* be able to track those changes across a rename and even 
> with a rename on one branch and changes on another; in my experience 
> it works well for filename renames, but git doesn't understand 
> directory renames at all, so new files do have to be moved to their 
> new locations manually.

yes, it copes in some cases - but i've had rather bad experiences with 
it.

the reason i raised this is because i tried to pull Sam's renames, and 
they created 48 conflicts.

>> I missed the discussion on this, what's the point of renaming all these 
>> files?
>
> I know there has been talk about this on and off for a long time (to 
> get all the arch code into arch/).  I don't know if there are any 
> mechanical reasons for it, on top of that.

hm, seems rather pointless to me, i thought there might be some better 
reasons for it. Historically we've put all include files into 
include/asm-* - why upset the decade-long status quo now without strong 
technical reasons?

	Ingo
