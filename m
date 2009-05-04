Return-Path: <linux-kernel-owner+w=401wt.eu-S1752735AbZEDFn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbZEDFn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 01:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751626AbZEDFnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 01:43:13 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:46781 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbZEDFnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 01:43:12 -0400
To: tridge@samba.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Steve French <smfrench@gmail.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>, LKML <linux-kernel@vger.kernel.org>
References: <524f69650905011318m34e0027dt57877d225b3fe2da@mail.gmail.com>
	<20090501210109.GA3079@infradead.org>
	<20090502013729.GI6996@linux.vnet.ibm.com>
	<20090502015927.GJ8822@parisc-linux.org>
	<18940.3862.34000.615391@samba.org>
	<20090502092204.GA32066@infradead.org>
	<18940.4762.726933.677059@samba.org> <20090503215727.GF1368@ucw.cz>
	<18942.6593.544212.571063@samba.org>
	<20090503225616.GD8633@ZenIV.linux.org.uk>
	<18942.9606.411013.714178@samba.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 03 May 2009 22:42:52 -0700
In-Reply-To: <18942.9606.411013.714178@samba.org> (tridge@samba.org's message of "Mon\, 4 May 2009 09\:15\:18 +1000")
Message-ID: <m1ljpdl8yr.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: tridge@samba.org, linux-kernel@vger.kernel.org, mjt@tls.msk.ru, linux-fsdevel@vger.kernel.org, hirofumi@mail.parknet.co.jp, shaggy@linux.vnet.ibm.com, smfrench@gmail.com, paulmck@linux.vnet.ibm.com, matthew@wil.cx, hch@infradead.org, pavel@ucw.cz, viro@ZenIV.linux.org.uk
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;tridge@samba.org
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tridge@samba.org writes:

> Hi Al,
>
>  > Practical consequences of establishing that kind of precedent (applying
>  > a patch on the grounds of nothing but vague references to possibly
>  > legal problems, with author explicitly refusing to explain exact reasons)
>  > can also be non-trivial...  And I'm not sure that it won't have legal
>  > ones as well, while we are at it.
>
> You are absolutely right. For that reason, I expect that anyone who
> does finally make the decision to include this patch, or something
> like it, will have had a long discussion with a lawyer first, and will
> fully understand the reasons for it.
>
> Meanwhile though, there is something we can do here in public, which
> is to discuss the technical merits of the proposed patch. It might be
> that you or someone else can come up with a better technical approach.
>
> I also realise that discussing the technical merits of a patch without
> first establishing the exact non-technical reasons for the patch is
> difficult, but as Hirofumi-san has shown, it is possible.

Great now we go from security theater to patent theater.
And even more it appears to be a shed painting project.

Fun to watch but no real content.

The reality is that without a clear understanding of what the bug is
it is impossible to review the code to see if it actually fixes the
bug.  So from a purely code side it is impossible to see if it the
patch does what is intended.


>From the few reports I have heard that the actual bug is not in the
linux kernel code but rather it sounds like a denial of service attack
against the implementation of http://uscode.house.gov/.  With the
attackers being able to inject a few bogus values, and cause lots of
mayhem.

Now in the linux kernel we work around lots of bugs from lots of
different sources, and this may be a place to work around someone
else's bug.  This does not appear to be a context where anyone is
concerned about a 0 day exploit, so we don't need to rush.  Further
the functionality has been the same in the same in all places for a
long time, and all of the pieces are at least in theory open to public
review.  So this should be a reasonable context for a public discussion.

The only reason I can see for not ultimately talking about things publicly
is if this is one company making shady deals with another company in which
case I do not see why the maintenance burden for those decision should
fall on the linux community as a whole.

So for the same reasons we always want a good description of the
reasons for a change in the linux kernel, to ensure we understand what
the change is for and can properly review it.  To ensure that the
submitter knows what they are talking about we need a good change
description.

My experience with special cases and running around the normal process is
that it always produces an inferior result.  This case seems no different.

So please let's treat a bug as a bug and make certain that everyone knows
what is going on, and that this isn't an attempt to foist maintenance
off someones purely local hack off onto the greater linux community.

Given the continual rate of change in the linux kernel whatever that config
option is supposed to protect will inevitably bitrot unless it is clear
what it is protecting, and someone bothers to test and verify it.

Eric
