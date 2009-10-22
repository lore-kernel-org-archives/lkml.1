Return-Path: <linux-kernel-owner+w=401wt.eu-S1755360AbZJVMOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbZJVMOQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 08:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755301AbZJVMOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 08:14:16 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:54282 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260AbZJVMOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 08:14:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=rqzdjWUeRG5MYRl7cfLPHYI5DjHh6PNKl9curm/njxAbei2IBL0hpId9hpgKVvsVb5
         EWf2FPVEarJQOGvc70707i1oh2tH5QEw44IWIzkuCzH7pDwXl25OCPVdd9bHNs8DUOuF
         SaB1vm8eLhfx/+getCDvHCEeLTegXdkubiThs=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <4AE0444B.5070603@zytor.com>
References: <20091013044925.GA28181@us.ibm.com>
	 <cfd18e0f0910152325m4a9125c2q18f36f5bd7d4a0@mail.gmail.com>
	 <20091016180631.GA31036@us.ibm.com>
	 <20091019174405.GE27627@count0.beaverton.ibm.com>
	 <4ADCDAA8.5080408@zytor.com>
	 <20091019235012.GF27627@count0.beaverton.ibm.com>
	 <cfd18e0f0910202126w1ebfa2e2u2ecbaa23b198d100@mail.gmail.com>
	 <4ADF06B7.50508@zytor.com>
	 <cfd18e0f0910220326w1a71b899s5ff0fce9e0a2b8ed@mail.gmail.com>
	 <4AE0444B.5070603@zytor.com>
Date: Thu, 22 Oct 2009 14:14:16 +0200
Message-ID: <cfd18e0f0910220514y1bd5967aj3a04bc3f5b38948b@mail.gmail.com>
Subject: Re: [RFC][v8][PATCH 9/10]: Define clone3() syscall
From: Michael Kerrisk <mtk.manpages@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matt Helsley <matthltc@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       randy.dunlap@oracle.com, arnd@arndb.de,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       Louis.Rilling@kerlabs.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu,
       linux-api@vger.kernel.org, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com,
       Pavel Emelyanov <xemul@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

On Thu, Oct 22, 2009 at 1:38 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 10/22/2009 07:26 PM, Michael Kerrisk wrote:
>>>
>>> "3" is number of arguments.
>>
>> sys_clone3(struct clone_struct __user *ucs, pid_t __user *pids)
>>
>> It appears to me that the number of arguments is 2.
>>
>
> It was 3 at one point... I'm not sure when that changed last :-/
>
>>> It's better than "extended" or something like
>>> that simply because "extended" just means "more than", and a number at
>>> least
>>> tells you *how much more than*.
>>
>> I'm not sure why you think including a number in the name tells us
>> "how much more than". Unless you are considering the numbering to be
>> version numbers, which apparently is not what you mean.
>
> It is a version number of sorts.

So, sometimes, a number in a system call should be the bit width of
some arguments(s), sometimes it should be the number of arguments, and
sometimes (well, just occasionally, as in mmap2() and clone()) -- it
should be a version number? Does the weather play any part in the
decision? ;-)

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface" http://blog.man7.org/
