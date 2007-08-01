Return-Path: <linux-kernel-owner+w=401wt.eu-S932635AbXHAN6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635AbXHAN6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 09:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932208AbXHAN6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 09:58:03 -0400
Received: from mail.windriver.com ([147.11.1.11]:52096 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932178AbXHAN6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 09:58:01 -0400
Message-ID: <46B09158.7010902@windriver.com>
Date: Wed, 01 Aug 2007 08:57:44 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Frysinger <vapier.adi@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>
Subject: Re: 2.6.23-rc1-mm2
References: <20070731230932.a9459617.akpm@linux-foundation.org> <20070801062501.GB7581@linux-sh.org> <8bd0f97a0708010058v76f13361q62e79fe39c1f0589@mail.gmail.com> <20070801011033.51679dd5.akpm@linux-foundation.org> <20070801134529.GB12456@infradead.org>
In-Reply-To: <20070801134529.GB12456@infradead.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Aug 2007 13:57:43.0566 (UTC) FILETIME=[EEAE82E0:01C7D443]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Wed, Aug 01, 2007 at 01:10:33AM -0700, Andrew Morton wrote:
>   
>> I was hoping for a 2.6.24 merge.  But I haven't actually looked at it yet. 
>> Hopefully Jason is planning to get it all out for review soonish.
>>     
>
> The current version is quite messy.  I'd be much happier if we could
> start with a light version that doesn't have all the intrusions to random
> code outside the kgdb core.
>
>   
I would disagree on at least one level. The KGDB tree is broken up into 
incremental units each layer adding more functionality and or arch 
specific pieces.

As an example, the KGDB core itself is:
http://git.kernel.org/?p=linux/kernel/git/jwessel/linux-2.6-kgdb.git;a=commit;h=53956620b1b293300c5ae99a783cf6a7ce8175f9

If you can point to some specific examples vs a blanket statement "is 
quite messy" perhaps I can explain what the changes are for and why they 
are needed.

Jason.
