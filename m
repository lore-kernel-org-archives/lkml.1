Return-Path: <linux-kernel-owner+w=401wt.eu-S1758602AbXIYPus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602AbXIYPus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 11:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756135AbXIYPuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 11:50:40 -0400
Received: from h90-m1.hosting90.cz ([81.0.225.70]:35789 "EHLO
	h90-m1.hosting90.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954AbXIYPuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 11:50:39 -0400
Message-ID: <46F92CBE.4090805@prepere.com>
Date: Tue, 25 Sep 2007 17:43:58 +0200
From: Miloslav Semler <majkls@prepere.com>
User-Agent: IceDove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: serge@hallyn.com, davidsen@tmr.com, philipp@marek.priv.at, 7eggert@gmx.de,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: Chroot bug
References: <46F2B59F.8090709@davidnewall.com> <46F2DDD0.3030500@tmr.com> <46F380E4.4040606@davidnewall.com> <20070924213215.GA32716@vino.hallyn.com> <46F83474.5040503@davidnewall.com> <20070924230008.GA3160@vino.hallyn.com> <46F8BC8A.7080006@davidnewall.com> <20070925114947.GA9721@vino.hallyn.com> <46F91417.9050600@davidnewall.com> <46F924E3.50205@davidnewall.com> <20070925153208.GO6800@stusta.de>
In-Reply-To: <20070925153208.GO6800@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk napsal(a):
> On Wed, Sep 26, 2007 at 12:40:27AM +0930, David Newall wrote:
>
>   
>> Miloslav Semler pointed out that a root process can chdir("..") out of its 
>> chroot.  Although this is documented in the man page, it conflicts with the 
>> essential function, which is to change the root directory of the process.  
>> In addition to any creative uses, for example Philipp Marek's loading 
>> dynamic libraries, it seems clear that the prime purpose of chroot is to 
>> aid security.  Being able to cd your way out is handy for the bad guys, but 
>> the good guys don't need it; there are a thousand better, safer solutions.
>> ...
>>     
>
> The bad guys most likely also now other tricks to escape the chroot.
>
> If you are root in the chroot you can e.g. mount the partition with the 
> root filesystem inside the chroot.
>
> If a bad guy becomes root inside a chroot it's game over.
>   
but why there keep 1000001th. It is same as:
There is milion ways howto dos your system.. Then we needn't repair bugs...
> cu
> Adrian
>
>   

