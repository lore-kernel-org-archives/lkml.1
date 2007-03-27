Return-Path: <linux-kernel-owner+w=401wt.eu-S1753563AbXC0KKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbXC0KKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 06:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbXC0KKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 06:10:31 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:1783 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbXC0KK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 06:10:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=k0YWvBqmJPnHIX9dEXzwHuqSCLkZlbTe9R7W2eiNpEr6mDVjbgB0B9w+zIzy/6RZjWj/P5ttsjCp5YvVnddKBMY6FDBQH6EqdMVsP9WTtGlyvyrKV34MnTV8zRF2d2kldxeflVaOdTH+5euqhENc8QAC01kjTAZ2ne2235JQpEQ=
Message-ID: <4608ED89.5040407@gmail.com>
Date: Tue, 27 Mar 2007 19:10:17 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Why is NCQ enabled by default by libata? (2.6.20)
References: <Pine.LNX.4.64.0703241232580.11608@p34.internal.lan> <20070324184300.3250fab0@the-village.bc.nu> <Pine.LNX.4.64.0703270554320.31853@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0703270554320.31853@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> Checking the benchmarks on various hardware websites, anandtech, 
> hothardware and others, they generally all come to the same conclusion 
> if there is only 1 thread using I/O (single user system) then NCQ off is 
> the best.

Are they testing using Linux?  I/O performance is highly dependent on 
workload and scheduling, so result on windows wouldn't be very useful. 
Posting some links here would be nice.

> I see 30-50MB/s faster speeds with NCQ turned off on two 
> different SW RAID5s.

You're testing raptors, right?  If the performance drop is that drastic 
and consistent over different workloads, we'll have to disable NCQ for 
raptors.  I'm not sure about other drives.  Care to perform tests over 
more popular ones (e.g. recent seagates or 7200rpm wds)?

-- 
tejun
