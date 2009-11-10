Return-Path: <linux-kernel-owner+w=401wt.eu-S1756757AbZKJPwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbZKJPwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 10:52:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756594AbZKJPwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 10:52:24 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:41353 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396AbZKJPwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 10:52:24 -0500
Message-ID: <4AF98C36.9040405@s5r6.in-berlin.de>
Date: Tue, 10 Nov 2009 16:52:22 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.23) Gecko/20090825 SeaMonkey/1.1.18
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] new -stable tag variant, Git workflow question
References: <20091110034831.GB26809@elte.hu>	 <20091110041452.GA25575@suse.de> <1257863388.4184.220.camel@mulgrave.site>
In-Reply-To: <1257863388.4184.220.camel@mulgrave.site>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
[...]
>> On Tue, Nov 10, 2009 at 04:48:31AM +0100, Ingo Molnar wrote:
>> > FYI, today i committed a scheduler performance fix that has a number of 
>> > commit prerequisites for -stable integration. Those commits are not 
>> > marked -stable.
[...]
>> > we can move this into the Git commit space too, and minimize the 
>> > work for the -stable team, via a new -stable tag variant.
[...]
> The question is, how important is this?
> 
> One of the assumptions behind the current setup is that I assume
> backports are independent (so the order of transmission doesn't matter
> that much).  This isn't always true, but the exceptions tend to get
> handled manually.  Part of what the above is requesting is an
> implementation that starts to care about ordering.

More importantly, isn't this against the character of the -stable kernel
branches as _safe and simple_ hotfix branches?

If a fix has a number of prerequisites which ar not -stable fixes
themselves, then it is more than a hint that this fix is not really well
suited for -stable.
-- 
Stefan Richter
-=====-==--= =-== -=-=-
http://arcgraph.de/sr/
