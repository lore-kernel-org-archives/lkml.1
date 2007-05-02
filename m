Return-Path: <linux-kernel-owner+w=401wt.eu-S1766885AbXEBRkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766885AbXEBRkJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 13:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766901AbXEBRkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 13:40:09 -0400
Received: from vsmtp14.tin.it ([212.216.176.118]:51826 "EHLO vsmtp14.tin.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766885AbXEBRkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 13:40:07 -0400
Date: Wed, 2 May 2007 19:39:48 +0200 (CEST)
From: l.genoni@oltrelinux.com
X-X-Sender: venom@Phoenix.oltrelinux.com
To: Daniel J Blueman <daniel.blueman@gmail.com>
cc: Rajib Majumder <rajibm2005@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, l.genoni@sns.it
Subject: Re: Kernel Scalability
In-Reply-To: <6278d2220705020843l718b3272k5d6ebf8b827d0806@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705021933320.14034@Phoenix.oltrelinux.com>
References: <6278d2220705020843l718b3272k5d6ebf8b827d0806@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2 May 2007, Daniel J Blueman wrote:

> Date: Wed, 2 May 2007 16:43:44 +0100
> From: Daniel J Blueman <daniel.blueman@gmail.com>
> To: Rajib Majumder <rajibm2005@gmail.com>
> Cc: Linux Kernel <linux-kernel@vger.kernel.org>
> Subject: Re: Kernel Scalability
> Resent-Date: Wed, 02 May 2007 17:44:58 +0200
> Resent-From: <l.genoni@sns.it>
> 
> On 2 May, 14:00, "Rajib Majumder" <rajibm2005@gmail.com> wrote:
>> Hi,
>> 
>> I am wondering if 2.4.x/2.6.x kernel is scalable enough to run on
>> 8-CPU hardware. Do we have any scalability comparison data between
>> 2.4/2.6 kernels and beyond 4-CPU?
>> 
>> If yes, is the scalablity is near linear?
>> 
>> Any input is appreciated.
>
> There are 128-processor IA64 systems which run recent 2.6 kernels out
> there; the per-processor counters, RCU and page-fault scalability work
> has been instrumental to the necessary scaling for decent resource
> usage on these.
>
> IIRC, there were some patches being developed to improve pagecache
> scalability lately too, but I guess it all depends on what kind of
> workload you have...
>
To stay on systems probably more familiar to the user who asked this 
question, there are also some 64 core X86_64 bot AMD and Intel out there, 
here the 2.6 kernel is doing 
very well even on those intel CPU with shared L2 cache.
I have some 16 and 32 core Opteron and never had scalability problems.
You have to pay a lot of attention to your kernel configuration  (100 HZ, 
just BKL preemption), and to the 
filesystems you decide to use.


