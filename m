Return-Path: <linux-kernel-owner+w=401wt.eu-S1752841AbXDISRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbXDISRZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 14:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbXDISRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 14:17:25 -0400
Received: from main.gmane.org ([80.91.229.2]:60426 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841AbXDISRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 14:17:24 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: init's children list is long and slows reaping children.
Date: Mon, 09 Apr 2007 14:09:51 -0400
Message-ID: <461A816F.4050507@tmr.com>
References: <m1hcru9rki.fsf@ebiederm.dsl.xmission.com> <20070406104301.GB19755@lnx-holt.americas.sgi.com> <m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com> <20070406163100.GA554@tv-sign.ru> <Pine.LNX.4.64.0704061119090.8738@alien.or.mcafeemobile.com> <m1wt0p5o1y.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0704061214450.8738@alien.or.mcafeemobile.com> <20070406191945.GA18255@elte.hu> <Pine.LNX.4.64.0704061427130.8738@alien.or.mcafeemobile.com> <Pine.LNX.4.64.0704061449231.6730@woody.linux-foundation.org> <20070409082847.GA2228@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Robin Holt <holt@sgi.com>,
       Chris Snook <csnook@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jack Steiner <steiner@americas.sgi.com>
X-Gmane-NNTP-Posting-Host: mail.tmr.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
In-Reply-To: <20070409082847.GA2228@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
>> On Fri, 6 Apr 2007, Davide Libenzi wrote:
>>>> or lets just face it and name it what it is: process_struct ;-)
>>> That'd be fine too! Wonder if Linus would swallow a rename patch like 
>>> that...
>> I don't really see the point. It's not even *true*. A "process" 
>> includes more than the shared signal-handling - it would include files 
>> and fs etc too.
>>
>> So it's actually *more* correct to call it the shared signal state 
>> than it would be to call it "process" state.
> 
> we could call it "structure for everything that we know to be ugly about 
> POSIX process semantics" ;-) The rest, like files and fs we've 
> abstracted out already.
> 
> 	Ingo
So are you voting for ugly_struct? ;-)

I do think this is still waiting for a more descriptive name, like 
proc_misc_struct or some such. Kernel code should be treated as 
literature, intended to be both read and readable.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

