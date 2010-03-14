Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759556Ab0CNSa7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 14:30:59 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:41306 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab0CNSa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 14:30:56 -0400
To: Greg KH <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Larry Finger <Larry.Finger@lwfinger.net>,
       WANG Cong <xiyou.wangcong@gmail.com>, Tejun Heo <tj@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] base firmware: Fix BUG from sysfs attributes change in commit a2db6842873c8e5a70652f278d469128cb52db70
References: <4b9be956.x5+yAHXGDfXer810%Larry.Finger@lwfinger.net>
	<alpine.LFD.2.00.1003131426480.3719@i5.linux-foundation.org>
	<alpine.LRH.2.00.1003132336380.12517@twin.jikos.cz>
	<alpine.LFD.2.00.1003131455420.3719@i5.linux-foundation.org>
	<m1fx43zhbd.fsf@fess.ebiederm.org>
	<alpine.LFD.2.00.1003132131470.3719@i5.linux-foundation.org>
	<20100314181131.GC28359@suse.de>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 14 Mar 2010 11:30:48 -0700
In-Reply-To: <20100314181131.GC28359@suse.de> (Greg KH's message of "Sun\, 14 Mar 2010 11\:11\:31 -0700")
Message-ID: <m11vfmzrfr.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: gregkh@suse.de, mingo@elte.hu, linux-kernel@vger.kernel.org, tj@kernel.org, xiyou.wangcong@gmail.com, Larry.Finger@lwfinger.net, jkosina@suse.cz, torvalds@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> On Sat, Mar 13, 2010 at 09:46:46PM -0800, Linus Torvalds wrote:
>> 
>> 
>> On Sat, 13 Mar 2010, Eric W. Biederman wrote:
>> > 
>> > It also only affects those fairly rare lockdep users as well, and the only
>> > affect is to throw a nasty warning message.  Isn't lockdep all about throwing
>> > nasty warning messages?
>> 
>> Hmm. The report has that "BUG: " message in it (and in the subject line), 
>> but you're right - it ends up being just a warning, not actually a real 
>> BUG() (which is a machine killer).
>> 
>> So yeah - it's not as bad as I thought. Sorry.
>
> It's a messy warning, I have patches that should fix the remaining ones
> that I will send to you tomorrow.

Greg if you have it that is great.  I started looking through the emails
I received and it looks like you weren't copied on all of them.  At this
point I will double check after you send out your changes to Linus.  That
we have everything I have seen reported.

Eric
