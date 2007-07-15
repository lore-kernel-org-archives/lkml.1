Return-Path: <linux-kernel-owner+w=401wt.eu-S1753295AbXGOEUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbXGOEUB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 00:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750958AbXGOETw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 00:19:52 -0400
Received: from main.gmane.org ([80.91.229.2]:45487 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902AbXGOETv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 00:19:51 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Subject: Re: [ANNOUNCE][RFC] PlugSched-6.5.1 for  2.6.22
Date: Sun, 15 Jul 2007 06:19:46 +0200
Message-ID: <f7c78t$lqe$1@sea.gmane.org>
References: <200707120117.20405.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: host-62-10-76-119.cust-adsl.tiscali.it
User-Agent: KNode/0.10.5
X-Face: ::w9}R^l{WGM\{y)C0QF@4^U,',W3Mk^X0HP)=:bKM^Z]A9+6bY6fe3}O*]fH{l<j1/9RTp  `KR0idy]Im#9^%}P5Dga'>AViT_'?&>&ufo2_X5Vs3C^tPO@drZRuu&6iK}x}~9`F\-dNZ>(p|V7`4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 July 2007 00:17, Al Boldi wrote:

> Peter Williams wrote:
>>
>> Probably the last one now that CFS is in the main line :-(.
> 
> What do you mean?  A pluggable scheduler framework is indispensible even in 
> the presence of CFS or SD.

Indeed, and I hope it gets merged, giving people the chance to test out
different schedulers easily, without having to do patching, de-patching,
re-patching and blah blah blah.

But somehow I doubt it'll get merged now. My bet is that it won't even be
taken into consideration, for the same reasons that ultimately drove Con
Kolivas to giving up on development of SD. And if it's so, chances are
people will get tired of trying to get it merged. :/

>> A patch for 2.6.22 is available at:
>>
>> <http://downloads.sourceforge.net/cpuse/plugsched-6.5.1-for-2.6.22.patch>
>>
>> Very Brief Documentation:
>>
>> You can select a default scheduler at kernel build time.  If you wish to
>> boot with a scheduler other than the default it can be selected at boot
>> time by adding:
>>
>> cpusched=<scheduler>
>>
>> to the boot command line where <scheduler> is one of: ingosched,
>> ingo_ll, nicksched, staircase, spa_no_frills, spa_ws, spa_svr, spa_ebs
>> or zaphod.  If you don't change the default when you build the kernel
>> the default scheduler will be ingosched (which is the normal scheduler).
> 
> Can't PlugSched include CFS and SD?

If I read the announcement correctly, those are the ones referred to as
'ingosched' and 'staircase' :)

-- 
Giuseppe "Oblomov" Bilotta

