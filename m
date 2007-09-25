Return-Path: <linux-kernel-owner+w=401wt.eu-S1758105AbXIYQCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbXIYQCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 12:02:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbXIYQB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 12:01:56 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:45980 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751782AbXIYQBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 12:01:55 -0400
Date: Tue, 25 Sep 2007 18:02:14 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Miloslav Semler <majkls@prepere.com>
Cc: serge@hallyn.com, davidsen@tmr.com, philipp@marek.priv.at, 7eggert@gmx.de,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: Chroot bug
Message-ID: <20070925160214.GP6800@stusta.de>
References: <46F380E4.4040606@davidnewall.com> <20070924213215.GA32716@vino.hallyn.com> <46F83474.5040503@davidnewall.com> <20070924230008.GA3160@vino.hallyn.com> <46F8BC8A.7080006@davidnewall.com> <20070925114947.GA9721@vino.hallyn.com> <46F91417.9050600@davidnewall.com> <46F924E3.50205@davidnewall.com> <20070925153208.GO6800@stusta.de> <46F92CBE.4090805@prepere.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46F92CBE.4090805@prepere.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2007 at 05:43:58PM +0200, Miloslav Semler wrote:
> Adrian Bunk napsal(a):
>> On Wed, Sep 26, 2007 at 12:40:27AM +0930, David Newall wrote:
>>
>>   
>>> Miloslav Semler pointed out that a root process can chdir("..") out of 
>>> its chroot.  Although this is documented in the man page, it conflicts 
>>> with the essential function, which is to change the root directory of the 
>>> process.  In addition to any creative uses, for example Philipp Marek's 
>>> loading dynamic libraries, it seems clear that the prime purpose of 
>>> chroot is to aid security.  Being able to cd your way out is handy for 
>>> the bad guys, but the good guys don't need it; there are a thousand 
>>> better, safer solutions.
>>> ...
>>>     
>>
>> The bad guys most likely also now other tricks to escape the chroot.
>>
>> If you are root in the chroot you can e.g. mount the partition with the 
>> root filesystem inside the chroot.
>>
>> If a bad guy becomes root inside a chroot it's game over.
>>   
> but why there keep 1000001th. It is same as:
> There is milion ways howto dos your system.. Then we needn't repair bugs...

Either something is aimed at being secure or it's not aimed at being 
secure.

For chroot it's documented that it does not prevent root from escaping 
the chroot so that's expected behavior, not a bug.

And regarding security, there's no difference whether there is 1 way or 
whether there are 1000001 ways for root to escape the chroot.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

