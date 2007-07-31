Return-Path: <linux-kernel-owner+w=401wt.eu-S1756912AbXGaJTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912AbXGaJTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 05:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753921AbXGaJTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 05:19:19 -0400
Received: from il.qumranet.com ([82.166.9.18]:45154 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753294AbXGaJTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 05:19:18 -0400
Message-ID: <46AEFE9E.1000204@argo.co.il>
Date: Tue, 31 Jul 2007 12:19:26 +0300
From: Avi Kivity <avi@argo.co.il>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Peter Zijlstra <peterz@infradead.org>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ck@vds.kolivas.org
Subject: Re: SD still better than CFS for 3d   ?(was Re: 2.6.23-rc1)
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <1185536610.502.8.camel@localhost> <20070729170641.GA26220@elte.hu> <1185839164.27166.7.camel@localhost> <1185863461.3092.4.camel@twins> <20070731085713.GA15136@elte.hu> <20070731101133.5ae6ac79@the-village.bc.nu> <20070731091359.GB15136@elte.hu>
In-Reply-To: <20070731091359.GB15136@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>
>> For the tty layer I'm waiting for the revoke code to get finished up 
>> and move from -mm into Linus tree. At that point the real evil 
>> lock_kernel related stuff in the tty layer can switch to using the 
>> revoke code for hangup paths and then other bits can be tackled.
>>     
>
> oh, wonderful! Alan, you are a true wizard :-) The tty layer is one of 
> the very few pieces of kernel code that scares the hell out of me :-)
>
>   

Maybe it should be kept crufty then.  Every kernel developer should have 
at least one part of the kernel he's afraid to go into ;-)


-- 
error compiling committee.c: too many arguments to function

