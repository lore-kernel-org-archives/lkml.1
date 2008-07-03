Return-Path: <linux-kernel-owner+w=401wt.eu-S1754350AbYGCPPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbYGCPPP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 11:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbYGCPPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 11:15:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44340 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196AbYGCPPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 11:15:00 -0400
Date: Thu, 3 Jul 2008 17:14:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Glauber Costa <gcosta@redhat.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: [GIT PULL] Userlib integration patches
Message-ID: <20080703151439.GA11801@elte.hu>
References: <200807011846.m61IkHWF014954@pobox-2.corp.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807011846.m61IkHWF014954@pobox-2.corp.redhat.com>
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


* Glauber Costa <gcosta@redhat.com> wrote:

> Ingo, please pull the latest master git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/glommer/linux-2.6-x86-integration.git master
> 
> It is based on your tip/master tree, and contains an update to the 
> userlib integration according to the mailing list discussions. You 
> should be able to wipe out the previous branch, and put this one on 
> instead.

hm, you reintroduced the subject line bugs i fixed in the series i 
picked up from you:

>       Don't use size specifiers
>       provide delay loop for x86_64
>       use rdtscll in read_current_timer for i386.
>       explicitly use edx in const delay function.
>       integrate delay functions
>       use something common for both architectures
>       don't clobber r8 nor use rcx
>       don't use word-size specifiers
>       adapt x86_64 getuser functions
>       rename threadinfo to TI
>       Don't use word-size specifiers on getuser_64
>       introduce __ASM_REG macro

could you please restore the proper commit entries? You can use 
git-rebase -i <the base you used> to quickly cycle through them.

please also rebase those commits to tip/auto-x86-next, not tip/master, 
that way it's pullable. (otherwise it would include all sorts of 
not-yet-for-upstream stuff that would make your commits non-pushable for 
a long time)

	Ingo
