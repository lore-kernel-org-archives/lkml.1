Return-Path: <linux-kernel-owner+w=401wt.eu-S1754721AbYIEUrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbYIEUrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 16:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbYIEUrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 16:47:37 -0400
Received: from main.gmane.org ([80.91.229.2]:47431 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbYIEUrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 16:47:36 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [v4l-dvb-maintainer] [PULL] http://linuxtv.org/hg/~mcisely/pvrusb2
Date: Fri, 05 Sep 2008 17:02:35 -0400
Message-ID: <48C19E6B.2090505@tmr.com>
References: <Pine.LNX.4.64.0808312020060.16986@cnc.isely.net> <20080902061821.4df5cba4@mchehab.chehab.org> <Pine.LNX.4.64.0809020815060.16986@cnc.isely.net> <48BD3FCC.2030206@linuxtv.org> <48BD4DCE.9020507@s5r6.in-berlin.de> <Pine.LNX.4.64.0809020933001.11377@cnc.isely.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Michael Krufky <mkrufky@linuxtv.org>,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
X-Gmane-NNTP-Posting-Host: pool-71-245-142-197.albyny.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
In-Reply-To: <Pine.LNX.4.64.0809020933001.11377@cnc.isely.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Isely wrote:

>> If you need this kind of safety measures against errors in future code
>> changes, could it be that you have some general QA problems?

That's always a problem with humans in the loop. I very much agree that 
one line or three is far safer against a hasty line insertion than only two.

In my own code I write one if it fits, three if it doesn't. Being easy 
to read is good, being hard to misread is better.
> 
> One of the points behind a good coding style is that it should encourage 
> code that is robust against trivial mistakes.  Prefering
> 
> 	if (a) {
> 		b;
> 	}
> 
> over
> 
> 	if (a)
> 		b;
> 
> I consider to be an example of this kind of simple safety.  (And I have 
> in the past seen people getting burned from the obvious error of 
> sticking a debug printf in between.)  ACTUALLY, I'd much, much rather 
> prefer
> 
> 	if (a) b;
> 
> however checkpatch.pl gets angry about that as well (even though the 
> kernel CodingStyle document would seem to actually allow this - it's 
> still one statement and since "b" is outside the normal flow then it's 
> "something to hide" and should be ok in any case).
> 
> 
>> (However, why waste time arguing over braces or not?)
> 
> Tell that to those who would use checkpatch.pl to gate incoming 
> changesets.
> 

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

