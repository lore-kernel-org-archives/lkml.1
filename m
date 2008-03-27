Return-Path: <linux-kernel-owner+w=401wt.eu-S1760862AbYC0Vrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760862AbYC0Vrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 17:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757619AbYC0Vr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 17:47:28 -0400
Received: from mail.tmr.com ([64.65.253.246]:51340 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757374AbYC0Vr2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 17:47:28 -0400
Message-ID: <47EC1651.7090300@tmr.com>
Date: Thu, 27 Mar 2008 17:49:05 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: "" <jamagallon@ono.com>
CC: Emmanuel Florac <eflorac@intellique.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: RAID-1 performance under 2.4 and 2.6
References: <20080325194306.4ac71ff2@galadriel.home> <47E975F8.3000702@redhat.com> <47E98108.9000906@tmr.com> <47E98712.6090203@redhat.com> <47E98DE4.9000906@tmr.com> <20080326090527.42286e8e@galadriel.home> <8CAC9F9E-60FE-40A5-A720-27BA63BEEADC@ono.com>
In-Reply-To: <8CAC9F9E-60FE-40A5-A720-27BA63BEEADC@ono.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J.A. Magallón wrote:

> But you shouldn't have to tweak anything.
> Let's forget for a moment calling dd a 'benchmark'. The fact is that a
> certain program (in its default behaviour, dd if=xxx of=yyy) is waaay
> slower in 2.6 than in 2.4. So something has gone nuts.

Ah, agreement from another direction. Yes, portable solutions often use 
tools like awk, grep, and sed, which do just the very thing which make 
2.6 unhappy. And to claim that this is a vm problem (hopefully not) and 
that Linux is no longer good at complex tasks like copying a large file 
a line at a time, at leat unless you have GBs of memory so it can 
"scale," I really hope that's very wrong.

> The typical question is 'who cares dd ?'. And the answer: all normal
> applications that just read and write, that do not use any *advise()
> because they tried to be portable, that are not rewritten and fancy
> optimized to take advantage of latest kernel knobs, in short, any normal
> app that just fopen()s and fread()s...

Major company seen in the news which has custom QA hardware which writes 
one very long line of ASCII every 100ms for 17hrs, and now they have to 
read it with awk or perl and write info to multiple data files.

> Seriously, are people telling that I have to tweak my app to get the
> same performance that in 2.4 ? The basic performance should be the same,
> and all those knobs should let you get _better_ throughput, not just the
> same. To say anything else is to hide the head on the floor...
> 
I just copied an 8GB DVD image from one drive to another. I checked, it 
doesn't go through a dial-up modem, it's just painfully *slow*.

I think the problem is that many developers *do* use big machines, with 
fast disk, lots of memory, and don't spend much time using (or making 
useful) more typical desktop configurations. And yes, these are "real" 
applications, and they run better on 2.4.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

