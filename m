Return-Path: <linux-kernel-owner+w=401wt.eu-S1030808AbXDJPTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030808AbXDJPTW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 11:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030680AbXDJPTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 11:19:22 -0400
Received: from main.gmane.org ([80.91.229.2]:58004 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030808AbXDJPTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 11:19:21 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: init's children list is long and slows reaping children.
Date: Tue, 10 Apr 2007 11:12:22 -0400
Message-ID: <461BA956.5010107@tmr.com>
References: <m1hcru9rki.fsf@ebiederm.dsl.xmission.com> <20070406104301.GB19755@lnx-holt.americas.sgi.com> <m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com> <20070406163100.GA554@tv-sign.ru> <Pine.LNX.4.64.0704061119090.8738@alien.or.mcafeemobile.com> <m1wt0p5o1y.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0704061214450.8738@alien.or.mcafeemobile.com> <20070406191945.GA18255@elte.hu> <Pine.LNX.4.64.0704061427130.8738@alien.or.mcafeemobile.com> <Pine.LNX.4.64.0704061449231.6730@woody.linux-foundation.org> <20070409082847.GA2228@elte.hu> <461A816F.4050507@tmr.com> <9B6136A3-52B4-4AE2-9805-21634E25530A@mac.com> <Pine.LNX.4.64.0704091239030.6730@woody.linux-foundation.org> <Pine.LNX.4.64.0704091302300.5940@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Robin Holt <holt@sgi.com>,
       Chris Snook <csnook@redhat.com>,
       Jack Steiner <steiner@americas.sgi.com>
X-Gmane-NNTP-Posting-Host: mail.tmr.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
In-Reply-To: <Pine.LNX.4.64.0704091302300.5940@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi wrote:
> On Mon, 9 Apr 2007, Linus Torvalds wrote:
> 
>> On Mon, 9 Apr 2007, Kyle Moffett wrote:
>>> Maybe "struct posix_process" is more descriptive?  "struct process_posix"?
>>> "Ugly POSIX process semantics data" seems simple enough to stick in a struct
>>> name.  "struct uglyposix_process"?
>> Guys, you didn't read my message.
>>
>> It's *not* about "process" stuff.  Anything that tries to call it a 
>> "process" is *by*definition* worse than what it is now. Processes have all 
>> the things that we've cleanly separated out for filesystem, VM, SysV 
>> semaphore state, namespaces etc.
>>
>> The "struct signal_struct" is the random *leftovers* from all the other 
>> stuff. It's *not* about "processes". Never has been, and never will be. 
> 
> I proposed "struct task_shared_ctx" but you ducked :)
> 
Descriptive, correct, I like it!

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

