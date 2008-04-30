Return-Path: <linux-kernel-owner+w=401wt.eu-S933305AbYD3W24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933305AbYD3W24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932972AbYD3W2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:28:41 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:1737 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764124AbYD3W2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:28:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Ynu0ZuiNtfZ8SoQLyeYcFPgxl934qPM++6wq7fTC8mDkc6k9Jo7iU86fAB9JnZcK3UM7tMKZqwKdgTj+Qfqjem6dpAbQcYq/a9FlYniKMO2TbRSu2uvIKDcamFjRM3ugSkdF/QKOdhWksY2StgBvuYRo+9TYCK5C0EsFJeAZnVc=
Message-ID: <4818F291.2050706@gmail.com>
Date: Thu, 01 May 2008 02:28:33 +0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>, rjw@sisk.pl,
       davem@davemloft.net, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       mingo@elte.hu
Subject: Re: Slow DOWN, please!!!
References: <20080429.190352.137408408.davem@davemloft.net> <200804302136.58005.rjw@sisk.pl> <20080430131537.1f7a0914.akpm@linux-foundation.org> <alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org> <20080430135405.ddc42075.akpm@linux-foundation.org> <4818E7E3.7080705@gmail.com> <20080430151007.0ace4fa2.akpm@linux-foundation.org> <alpine.LFD.1.10.0804301513350.2980@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0804301513350.2980@woody.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds пишет:
> 
> On Wed, 30 Apr 2008, Andrew Morton wrote:
>>> For busy (or lazy) people like myself, the big problem with linux-next are
>>> the frequent merge breakages, when pulling the tree stops with "you are in
>>> the middle of a merge conflict".
>> Really?  Doesn't Stephen handle all those problems?  It should be a clean
>> fetch each time?
> 
> It should indeed be a clean fetch, but I wonder if Dmitri perhaps does a 
> "git pull" - which will do the fetch, but then try to _merge_ that fetched 
> state into whatever the last base Dmitri happened to have.
> 
> Dmitry: you cannot just "git pull" on linux-next, because each version of 
> linux-next is independent of the next one. What you should do is basically
> 
> 	# Set this up just once..
> 	git remote add linux-next git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
> 
> and then after that, you keep on just doing
> 
> 	git fetch linux-next
> 	git checkout linux-next/master
> 
> which will get you the actual objects and check out the state of that 
> remote (and then you'll normally never be on a local branch on that tree, 
> git will end up using a so-called "detached head" for this).
> 
> IOW, you should never need to do any merges, because Stephen did all those 
> in linux-next already.

Linus, thanks a lot for the detailed explanation. Indeed, it seems that I foolishly
tried to duplicate Stephen's work. In the future I'll do as you suggest here.

Dmitri

> 
> 			Linus
> 

