Return-Path: <linux-kernel-owner+w=401wt.eu-S1757178AbZCAPFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178AbZCAPFU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 10:05:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753411AbZCAPFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 10:05:05 -0500
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:43144 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964AbZCAPFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 10:05:04 -0500
Message-ID: <49AAA41A.9070800@krogh.cc>
Date: Sun, 01 Mar 2009 16:04:58 +0100
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: john stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29-rc6
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>  <49A6F39F.9040801@krogh.cc>  <alpine.LFD.2.00.0902261232570.3111@localhost.localdomain>  <49A6FEE2.90700@krogh.cc> <1f1b08da0902261319k7a60d80xaafc1101facfd2d9@mail.gmail.com> <49A70B24.6090706@krogh.cc> <alpine.LFD.2.00.0902261344440.3111@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902261344440.3111@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 26 Feb 2009, Jesper Krogh wrote:
>>> Also mind sending the full dmesg for both kernels?
>> http://krogh.cc/~jesper/dmesg-2.6.29-rc6.txt
>> http://krogh.cc/~jesper/dmesg-2.6.26.8.txt
> 
> Try changing
> 
> 	#define QUICK_PIT_MS 15
> 
> in arch/x86/kernel/tsc.c into something bigger. Let's say just doubling 
> it to 30. Does that change anything?

It seems to "slow down" the process (time from bootup to first clock 
reset).

Mar  1 15:38:41 quad01 ntpd[4603]: synchronized to LOCAL(0), stratum 13
Mar  1 15:38:41 quad01 ntpd[4603]: kernel time sync status change 0001
Mar  1 15:39:47 quad01 ntpd[4603]: synchronized to 10.194.133.13, stratum 4
Mar  1 15:43:02 quad01 ntpd[4603]: synchronized to 10.194.133.12, stratum 4
Mar  1 15:53:41 quad01 ntpd[4603]: time reset -0.352221 s
Mar  1 15:57:18 quad01 ntpd[4603]: synchronized to LOCAL(0), stratum 13
Mar  1 15:58:23 quad01 ntpd[4603]: synchronized to 10.194.133.13, stratum 4
jk@quad01:~$ w
  16:03:29 up 28 min,  2 users,  load average: 0.04, 0.01, 0.00

-- 
Jesper
