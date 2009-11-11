Return-Path: <linux-kernel-owner+w=401wt.eu-S1759375AbZKKVo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759375AbZKKVo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 16:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759325AbZKKVo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 16:44:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50238 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759324AbZKKVo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 16:44:27 -0500
Message-ID: <4AFB301C.3050800@zytor.com>
Date: Wed, 11 Nov 2009 13:43:56 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] new -stable tag variant, Git workflow question
References: <20091110034831.GB26809@elte.hu>  <20091110041452.GA25575@suse.de> <1257863388.4184.220.camel@mulgrave.site>  <20091110193747.GB12686@suse.de> <1257965424.11985.9.camel@mulgrave.site>  <alpine.LFD.2.01.0911111153390.31845@localhost.localdomain> <1257970010.11985.17.camel@mulgrave.site> <alpine.LFD.2.01.0911111211270.31845@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0911111211270.31845@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2009 12:14 PM, Linus Torvalds wrote:
> 
> 
> On Wed, 11 Nov 2009, James Bottomley wrote:
>>
>> So, now that you're showing an interest in all of this, how about I send
>> you the final update hook to add to your tree?  It will produce less
>> latency than the cron job I run on kernel.org to pull your tree into one
>> I have here ever twenty minutes or so and run the hooks.
> 
> Quite frankly, I'd much rather not run hooks on my tree directly. The less 
> that can possibly get screwed up with my kernel.org tree, the happier I 
> am. So in many ways, I really prefer the whole "done separately by others" 
> approach.
> 
> But hey, send the hook to me, and I'll think about it.
> 

One thing we might be able to do is to create an "exploder hook" on your
tree - something that asynchronously broadcasts a notification that
anyone can subscribe to.

	-hpa

