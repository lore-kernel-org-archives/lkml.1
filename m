Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933252Ab0BFXE6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 18:04:58 -0500
Received: from mail-iw0-f189.google.com ([209.85.223.189]:42953 "EHLO
	mail-iw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932999Ab0BFXE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 18:04:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Wn91tVImf8zOPUQ5h59ExeaGZr6ynWTNVCly5ws83GOLVRFsOt7YbaHzkRTNSIGP7o
         fEjyxCUTwsUi115xpz30DPUIeiVLTNCgZi15wzwv34LJFPwuuMBKEJFb8lDY2KjukbFm
         NN66FOW0MjKfabnUEvqpf50xqeDojg/RjJMSM=
Message-ID: <4B6DF5FD.5030708@gmail.com>
Date: Sat, 06 Feb 2010 15:06:37 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.33-rc7
References: <alpine.LFD.2.00.1002061422430.3829@localhost.localdomain> <alpine.LFD.2.00.1002061445210.3829@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1002061445210.3829@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/10 14:49, Linus Torvalds wrote:
>
>
> On Sat, 6 Feb 2010, Linus Torvalds wrote:
>>
>> But we've certainly fixed a few things, and it's been a week, so here's
>> -rc7. I wish I could say that it's the last -rc, but I strongly doubt
>> that, and we'll almost certainly have at least one more.
>
> Oh, and I forgot to ask one thing I had intended to ask in the release
> notes..
>
> Do people really care about the old-fashioned tar.gz and patch.gz files?
> I've always uploaded the tar-files and patches compressed with gzip,
> because that's the "traditional" way, and then we have a script that also
> re-compresses things as 'bz2' because it compresses better and many people
> are bandwidth-limited and much prefer the better compression.
>
> Of course, if you really care about bandwidth, you're better off just
> fetching the git trees instead, but the question for non-git users is:
>
>     Would it be ok to _only_ have the 'bz2' patches and tar-balls?
>
> Having two copies of every large file seems silly, if nobody really
> requires the traditional .gz format..
>
> 		Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


having .bz2 is always what I use, but one thing I've noticed if you
have a system without bzip2(or whatever the package tar depends on), tar 
wont work with those.
I'd say keep with .tar.gz this way any system will always
uncompressed.

Justin P. Mattock

