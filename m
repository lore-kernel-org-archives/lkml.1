Return-Path: <linux-kernel-owner+w=401wt.eu-S1161151AbXAZSYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161151AbXAZSYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 13:24:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161150AbXAZSYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 13:24:50 -0500
Received: from main.gmane.org ([80.91.229.2]:41554 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161149AbXAZSYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 13:24:48 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: O_DIRECT question
Date: Fri, 26 Jan 2007 13:23:28 -0500
Message-ID: <45BA4720.5010406@tmr.com>
References: <6d6a94c50701101857v2af1e097xde69e592135e54ae@mail.gmail.com> <45B90D19.60106@cfl.rr.com> <45B916F2.4070906@tls.msk.ru> <200701252211.39017.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
Cc: Michael Tokarev <mjt@tls.msk.ru>, Phillip Susi <psusi@cfl.rr.com>,
       Linus Torvalds <torvalds@osdl.org>, Viktor <vvp01@inbox.ru>,
       Aubrey <aubreylee@gmail.com>, Hua Zhong <hzhong@gmail.com>,
       Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org,
       hch@infradead.org, kenneth.w.chen@in
X-Gmane-NNTP-Posting-Host: mail.tmr.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
In-Reply-To: <200701252211.39017.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Denis Vlasenko wrote:
> On Thursday 25 January 2007 21:45, Michael Tokarev wrote:
>> Phillip Susi wrote:
>>> Denis Vlasenko wrote:
>>>> You mean "You can use aio_write" ?
>>> Exactly.  You generally don't use O_DIRECT without aio.  Combining the
>>> two is what gives the big win.
>> Well, it's not only aio.  Multithreaded I/O also helps alot -- all this,
>> say, to utilize a raid array with many spindles.
>>
>> But even single-threaded I/O but in large quantities benefits from O_DIRECT
>> significantly, and I pointed this out before.
> 
> Which shouldn't be true. There is no fundamental reason why
> ordinary writes should be slower than O_DIRECT.
> 
Other than the copy to buffer taking CPU and memory resources.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

