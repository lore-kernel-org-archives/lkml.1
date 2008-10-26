Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697AbYJZS2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbYJZS2o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 14:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbYJZS2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 14:28:34 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:5364 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbYJZS2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 14:28:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=OKM6JapIZ4x6jjE7ZSIx2ttU0QVDq1YoeY9rPkdeqo5ApyYX3jN3pvO3VTf7AvPRGP
         +BWfYwafqI39dZXvnPc7hz90iYWnF0QlQ/b5p5qXKwSWxXLOMgcHpD7+3lVWCKyCi44N
         GI+Ov9/1ttD56TGw+kmwNcrLj3U33t2kdbg9A=
Message-ID: <4904B6CC.7000403@gmail.com>
Date: Sun, 26 Oct 2008 19:28:28 +0100
From: "Mikko C." <mikko.cal@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080927)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Bug in workqueues [was: Usb devices randomly aren't detected
 with 2.6.28-rc1-git1]
References: <Pine.LNX.4.44L0.0810261327170.25044-100000@netrider.rowland.org> <200810261855.47580.rjw@sisk.pl> <alpine.LFD.2.00.0810261057290.5200@nehalem.linux-foundation.org> <200810261914.40825.rjw@sisk.pl> <alpine.LFD.2.00.0810261117030.5200@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0810261117030.5200@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds ha scritto:
> On Sun, 26 Oct 2008, Rafael J. Wysocki wrote:
>   
>> OK, I've closed bug #11853 with this assumption.  Mikko, if it happens again
>> with 2.6.28-rc1-git3 or later, please reopen.
>>     
>
> Note: I tried to find Mikko's config, but zlin.dk times out. So I cannot 
> check that he actually has CONFIG_HOTPLUG_CPU off, which is probably 
> required to actually trigger the bug. 
>   
I have:
# CONFIG_HOTPLUG_CPU is not set

Here's the full config: http://pastebin.com/d1481da76
Does -rc1-git2 not have the fix yet?
If not, I'll wait for -git3 and report back.

> But it does sound likely.
>
> However, the "Thunderbird crashes out for me" thing in that same thread 
> may be totally unrelated.
>   
My thunderbird freezes when I receive a message (because it plays a 
sound I guess).
So it's probably related to some sound issues.
Thanks
