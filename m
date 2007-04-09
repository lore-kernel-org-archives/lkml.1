Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbXDITaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbXDITaH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 15:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbXDITaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 15:30:07 -0400
Received: from smtpout.mac.com ([17.250.248.186]:59354 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbXDITaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 15:30:05 -0400
In-Reply-To: <461A816F.4050507@tmr.com>
References: <m1hcru9rki.fsf@ebiederm.dsl.xmission.com> <20070406104301.GB19755@lnx-holt.americas.sgi.com> <m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com> <20070406163100.GA554@tv-sign.ru> <Pine.LNX.4.64.0704061119090.8738@alien.or.mcafeemobile.com> <m1wt0p5o1y.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0704061214450.8738@alien.or.mcafeemobile.com> <20070406191945.GA18255@elte.hu> <Pine.LNX.4.64.0704061427130.8738@alien.or.mcafeemobile.com> <Pine.LNX.4.64.0704061449231.6730@woody.linux-foundation.org> <20070409082847.GA2228@elte.hu> <461A816F.4050507@tmr.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <9B6136A3-52B4-4AE2-9805-21634E25530A@mac.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Robin Holt <holt@sgi.com>,
       Chris Snook <csnook@redhat.com>,
       Jack Steiner <steiner@americas.sgi.com>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: init's children list is long and slows reaping children.
Date: Mon, 9 Apr 2007 15:28:44 -0400
To: Bill Davidsen <davidsen@tmr.com>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 09, 2007, at 14:09:51, Bill Davidsen wrote:
> Ingo Molnar wrote:
>> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>> On Fri, 6 Apr 2007, Davide Libenzi wrote:
>>>>> or lets just face it and name it what it is: process_struct ;-)
>>>> That'd be fine too! Wonder if Linus would swallow a rename patch  
>>>> like that...
>>> I don't really see the point. It's not even *true*. A "process"  
>>> includes more than the shared signal-handling - it would include  
>>> files and fs etc too.
>>>
>>> So it's actually *more* correct to call it the shared signal  
>>> state than it would be to call it "process" state.
>> we could call it "structure for everything that we know to be ugly  
>> about POSIX process semantics" ;-) The rest, like files and fs  
>> we've abstracted out already.
> So are you voting for ugly_struct? ;-)
>
> I do think this is still waiting for a more descriptive name, like  
> proc_misc_struct or some such. Kernel code should be treated as  
> literature, intended to be both read and readable.

Maybe "struct posix_process" is more descriptive?  "struct  
process_posix"?  "Ugly POSIX process semantics data" seems simple  
enough to stick in a struct name.  "struct uglyposix_process"?

Cheers,
Kyle Moffett

