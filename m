Return-Path: <linux-kernel-owner+w=401wt.eu-S1751734AbZL2VAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734AbZL2VAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 16:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbZL2VAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 16:00:39 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:44445 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbZL2VAj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 16:00:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DP7OqTCENgLQxjCp3bPGhZwN/i4k0kuQgysjjF8rB7MJ4B4LxdQMz8Z7Etl67nQXQw
         I+sGIhPz2hpPB18Mtbo/8D1v2NNHmzzh/AJdBHC7gNlX7LAee43e4t5GSeHUR4xrVBEj
         evo/0PehA87qGpVs/4q3QcvkF0grOrpoajKMc=
MIME-Version: 1.0
In-Reply-To: <4B3A64A8.5040104@garzik.org>
References: <alpine.LFD.2.00.0912291416230.4967@localhost>
	 <4B3A5B15.5060807@garzik.org> <20091229195608.GG4815@const>
	 <4B3A64A8.5040104@garzik.org>
Date: Tue, 29 Dec 2009 16:00:35 -0500
Message-ID: <ea6602020912291300x322ced07j4a6268cda7de4a06@mail.gmail.com>
Subject: Re: what's the purpose of MAXHOSTNAMELEN?
From: Vikram Dhillon <dhillonv10@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I care about Hurd :D, but yah as it is mentioned before, would it
sometime in future be possible to remove this from the kernel ?

Regards,
Vikram Dhillon

~~~
There are lots of Linux users who don't care how the kernel works, but
only want to use it. That is a tribute to how good Linux is.
-- Linus Torvalds



On Tue, Dec 29, 2009 at 3:20 PM, Jeff Garzik <jeff@garzik.org> wrote:
> On 12/29/2009 02:56 PM, Samuel Thibault wrote:
>>
>> Jeff Garzik, le Tue 29 Dec 2009 14:40:05 -0500, a écrit :
>>>
>>> On 12/29/2009 02:19 PM, Robert P. J. Day wrote:
>>>>
>>>> arch/s390/include/asm/param.h:#define MAXHOSTNAMELEN    64      /* max
>>>> length of hostname */
>>>>
>>>>   so lots of people define it but no one uses it.  it *is* exported to
>>>> user space in /usr/include/asm/param.h, but i still have no idea what
>>>> it's for in user space.  obsolete?
>>>
>>> According to RFC 1034, "Each node has a label, which is zero to 63
>>> octets in length"
>>
>> That's for Internet networks.  Other kinds of networks could implement
>> more.  It could make sense to restrict ourself to Internet standards,
>> but we don't :)
>
> Er huh?  That was a description of the origin of the limit.
>
> And as a point of fact, we do restrict ourself to that:
>
>        #define __NEW_UTS_LEN 64
>
>        struct new_utsname {
>                char sysname[__NEW_UTS_LEN + 1];
>                char nodename[__NEW_UTS_LEN + 1];
>
>
>
>>> What is it used for in userspace, and why is it export from the kernel?
>>
>> Gethostname, typically, but also all kinds of functions that provide a
>> hostname.  It's also quite often completely badly used, for instance for
>> getnameinfo()...
>>
>> You have Debian's list on
>> http://unstable.buildd.net/buildd/hurd-i386_Failed.html
>
> No one cares about Hurd.
>
>        Jeff
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
