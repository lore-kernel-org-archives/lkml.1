Return-Path: <linux-kernel-owner+w=401wt.eu-S1755547AbZGCKVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbZGCKVY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 06:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbZGCKVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 06:21:17 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:51457 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbZGCKVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 06:21:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pfNDM7IZ3iCKRr/xd3XbWT60sk2v3so1lKEh83J8j9PC+w5hyERgzpZKoVuxN+ZONJ
         Pz0qvAHHyo+vQtFf5QT8ActQ4aNnfjiz4ZhmKu3S9XB+rYakRsJqOeb5iqVsxAw+nVNr
         3U10k0JwmLksHh1jl3yDTHR34/ZLIdQf+CZaY=
Date: Fri, 3 Jul 2009 18:23:25 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Changli Gao <xiaosuo@gmail.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: PROPOSAL: extend pipe() to support NULL argument.
Message-ID: <20090703102325.GK5880@cr0.nay.redhat.com>
References: <20090703030008.GD5880@cr0.nay.redhat.com> <412e6f7f0907022108p7c533ed2wd16fceb0f282ed62@mail.gmail.com> <20090703051917.GE5880@cr0.nay.redhat.com> <412e6f7f0907022242r52ad981fyd51c2a55f41ab228@mail.gmail.com> <20090703071504.GG5880@cr0.nay.redhat.com> <412e6f7f0907030040v6133badat7058186a01d78f44@mail.gmail.com> <20090703081655.GH5880@cr0.nay.redhat.com> <412e6f7f0907030127u3d6806dfo9168600e7c71b241@mail.gmail.com> <20090703094229.GI5880@cr0.nay.redhat.com> <412e6f7f0907030259m5556ee2fobbb58d377bce4d17@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <412e6f7f0907030259m5556ee2fobbb58d377bce4d17@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 03, 2009 at 05:59:10PM +0800, Changli Gao wrote:
>On Fri, Jul 3, 2009 at 5:42 PM, Amerigo Wang<xiyou.wangcong@gmail.com> wrote:
>>>I said: It just a special case. Fixing sendfile() won't fix everything.
>>
>> What do you want? Just saving an fd, isn't it?
>>
>> sendfile() does this but you said it's buggy, if you fix it, what is the
>> rest problem?
>>
>You should know why Linux invented splice(2). Not all of the problems
>can be solved by sendfile(2).

Sure, it definitely can be seen from the interface....

>
>>>
>>>In fact, sendfile(2) is implemented via splice(2) infrastructure. The
>>>logic is the same, and much clever than yours. Dive into its code, you
>>>will find the reason why it must be blocked on outfd.
>>
>>
>> Sure, this is done in user-space, definitely....
>>
>Did you review the code of sendfile(2)? 

Not at all.

I just wanted to show what I wanted to say, not to re-implement
sendfile(2).
