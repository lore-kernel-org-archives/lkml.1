Return-Path: <linux-kernel-owner+w=401wt.eu-S1761669AbXIJXES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761669AbXIJXES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 19:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757935AbXIJXEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 19:04:06 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:50769 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015AbXIJXEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 19:04:05 -0400
Message-ID: <46E5CBB5.9030101@gmail.com>
Date: Tue, 11 Sep 2007 00:56:53 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>, perex@suse.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] unexport sys_{open,read}
References: <20070909203920.GA11764@infradead.org> <20070909145940.0b41c8a5.akpm@linux-foundation.org> <20070910090808.GA31204@infradead.org> <20070910022324.c69e1897.akpm@linux-foundation.org> <20070910124358.GB21089@ftp.linux.org.uk> <20070910102556.de35e825.akpm@linux-foundation.org> <20070910195821.GH3563@stusta.de> <20070910131759.a7b2dce7.akpm@linux-foundation.org> <20070910221848.GJ3563@stusta.de> <46E5C21C.8040609@gmail.com> <20070910224112.GK3563@stusta.de>
In-Reply-To: <20070910224112.GK3563@stusta.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2007 12:41 AM, Adrian Bunk wrote:

> On Tue, Sep 11, 2007 at 12:15:56AM +0200, Rene Herman wrote:
>> On 09/11/2007 12:18 AM, Adrian Bunk wrote:
>>
>>> On Mon, Sep 10, 2007 at 01:17:59PM -0700, Andrew Morton wrote:
>>>> There is no benefit in making some rigid set of rules.
>>> Is is considered beneficial to provide API stability for external modules 
>>> or not?
>> If I may...
>>
>> Yes, it is. Just not at any significant cost and Andrew is saying that he 
>> considers the _UNUSED() thing not significant.
> 
> But there is no API stability for external modules this way.

I agree that doing things only half is semi-regularly worse than doing them 
not at all, and this specific case might be the worst example of all, as I 
read that using sys_open/read is actively harmful, so, well...

I read the thread since I tend to keep lots of external crap around. Not in 
any way that would mean I'd have any grounds for complaining about anything; 
mostly just driver stuff in various states of completeness that I never seem 
to get around to cleaning up enough to submit to anyone.

But as such, I can comment on the fact that I'm much more likely to notice 
the warning than I am to notice a thread on LKML, say. How much more likely 
I'd be to then also actually do anything about it before it just breaks 
anyway is another matter, but again, well...

> It simply doesn't make sense to give the few sys_open() abusers even 
> more grace period while changes to the IRQ API affecting nearly everyone 
> are allowed without any requirements of ensuring API stability.
> 
> I'm not a fan of API stability for external modules, but if API 
> stability was considered important it should be done consequently and 
> not only for some patches that have the bad fate of having to go through 
> Andrew to Linus.

In this case I believe it makes sense to just rip it out, but generally it 
doesn't need to be such a fully robotic yes/no decision, I'd say.

Rene.
