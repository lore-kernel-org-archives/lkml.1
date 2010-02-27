Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968162Ab0B0KKN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 05:10:13 -0500
Received: from mail-qy0-f179.google.com ([209.85.221.179]:61126 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968123Ab0B0KKL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 05:10:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WzdoiJjhYeOm1eJJowhj5252pLvC97O21FQxJhvuc59vXC1kmnsHo0dNONI/JmtzZ9
         A2xZgwGRZURKo5/IOW7zhzy+fpwicwySwYSOQoOMKH2WS+pJdqDT9Jp3bZjsDDKfYJp5
         zYG9HZ65c3oCkqcBGY1/iqEmK5q1474Tc6SqI=
MIME-Version: 1.0
In-Reply-To: <4B88E4F3.4010308@cauwe.org>
References: <alpine.LFD.2.00.1002241740410.4245@localhost.localdomain>
	 <alpine.LFD.2.00.1002262041020.4245@localhost.localdomain>
	 <4B88E4F3.4010308@cauwe.org>
Date: Sat, 27 Feb 2010 19:10:09 +0900
Message-ID: <49b7c2351002270210m6a1d2534qa64aaeaba7a61b92@mail.gmail.com>
Subject: Re: [ANNOUNCE] 2.6.33-rt3
From: GeunSik Lim <leemgs1@gmail.com>
To: Xavier Miller <xavier.miller@cauwe.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Clark Williams <williams@redhat.com>, nando@ccrma.stanford.edu,
       Carsten Emde <ce@ceag.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The name is -rt4, not -rt3
> Xavier Miller.
Hi Xavier.
When I checked -rt tag currently, tag name is -rt4 based 2.6.33.
So, I changed -rt tag name to -rt4.
Test result is normal with 2.6.33-rt4 on
my desktop(Q6600, SSD64G, DDR2 2GRAM) at least.  :)

Thanks,

On Sat, Feb 27, 2010 at 6:25 PM, Xavier Miller <xavier.miller@cauwe.org> wrote:
> Hello,
>
> The name is -rt4, not -rt3
>
> Xavier Miller.
>
> Le 26/02/10 20:54, Thomas Gleixner a écrit :
>> We are pleased to announce the next update to our new preempt-rt
>> series.
>>
>>     - Update to 2.6.33
>>
>>     - rt fixes:
>>
>>                Peter Zijlstra (1):
>>              highmem, -rt: Implement pfn and prot kmaps
>>
>>       Thomas Gleixner (2):
>>                      x86: pci: Prevent mmconfig memory corruption
>>                      mmc: omap_hsmmc: Fix the locking mess
>>
>> A note on the development process:
>>
>>   The rt/2.6.33 branch is now stabilization only. The rt/head branch
>>   will follow linus tree from now on, so it will inherit all
>>   (mis)features which come in the merge window.
>>
>> Download locations:
>>
>>    http://www.kernel.org/pub/linux/kernel/projects/rt/
>>
>> Git development branch:
>>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git rt/head
>>
>> Git release branch:
>>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git rt/2.6.33
>>
>> Gitweb:
>>    http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=shortlog;h=rt/2.6.33
>>
>> Information on the RT patch can be found at:
>>
>>    http://rt.wiki.kernel.org/index.php/Main_Page
>>
>> To build the 2.6.33-rt3 tree, the following patches should be
>> applied:
>>
>>    http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.33.tar.bz2
>>    http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.33-rt3.bz2
>>
>> Enjoy !
>>
>>       tglx
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Regards,
GeunSik Lim ( Samsung Electronics )
Blog : http://blog.naver.com/invain/
e-Mail: geunsik.lim@samsung.com
           leemgs@gmail.com , leemgs1@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
