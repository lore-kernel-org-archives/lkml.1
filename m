Return-Path: <linux-kernel-owner+w=401wt.eu-S1760557AbZEMPGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760557AbZEMPGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 11:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759848AbZEMPGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 11:06:30 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:22195 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758987AbZEMPG3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 11:06:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GSCTYYcD21MdmbcsK7wQxTvSnuymRU+w+1C9qwSBRZpeeyoxDmkALLhac4ylgdtWTq
         98K160yqa0lRTVG7+e+DBWyu8UyDITYW48uFJTMGymBoljFM7NJ12ckMovovmEVUR66i
         poLFByB/LPVA8hRNDg9YQFn3aJqn0Q0rItLDk=
MIME-Version: 1.0
In-Reply-To: <20090513113357.GA11773@hack>
References: <1242180268.31161.24.camel@centos51> <20090513113357.GA11773@hack>
Date: Thu, 14 May 2009 00:06:30 +0900
Message-ID: <49b7c2350905130806jc02a4dfg8b04ec2de4fb1ff4@mail.gmail.com>
Subject: Re: [PATCH]man-pages : section 9 for kernel api description.
From: GeunSik Lim <leemgs1@gmail.com>
To: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: mtk.manpages@gmail.com, tovalds@linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your opinion.

2009/5/13 Américo Wang <xiyou.wangcong@gmail.com>:
> On Wed, May 13, 2009 at 11:04:28AM +0900, GeunSik Lim wrote:
>>
>>
>>Dear Michael Kerrisk,
>>
>>Are you maintainer of man-pages(man-pages-3.XX.tar.gz)?
>>I am not sure...
>
> Yes, he is.
>
>>
>>I use fedora 9 distribution as Linux based Desktop OS currently.
>>I have one proposal about "#> man <linux-kernel-api>" command.
>>Can you tell me your opinion about below patch?
>>Thanks reading.
>>
>>commit 45e950c98412c002c47254507a199731315c7c2b
>>Author: GeunSik,Lim <leemgs1@gmail.com>
>>Date:   Wed May 13 10:49:47 2009 +0900
>>
>>    Append Section 9 info of man command.
>>
>>    We view description of the Linux kernel API with man command.
>>       For example,
>>       Fedoar9#> yum install kernel-doc*
>>       Fedora9#> man kobject_rename  or
>>       Fedora9#> man kthread_create
>
> Why?
> Why do you want kernel api doc be in man pages?
> Why not just browsing the kernel source code?
>
I want Michael to append patch file  in the man-pages source that I
sent because
Many linux distributions (ex: Fedora , openSUSE, and so on ) already
support  kernel api for man currently.
In general, kernel api(ex:kernel-doc-2.6.29.1-30.fc10.noarch.rpm) is
located in the
/usr/share/man/man9/ directory when we installed linux distribution
like Fedora by default.
So, I think that we need description and section 9 folder(man9) in the
man-pages source
to understand  meaning of man 9.


> Kernel APIs are not stable at all, this is also a reason why you
> should not include their doc into man pages.
I agree that Kernel APIs is not stable.
But, I believe that we can utilize "#> man <linux-kernel-api>" command
in the own
Linux distribution easy to use about "uname -a" Linux kernel version.
This support is a valuable. I think that The problem deserves solving.

Thanks reading.

>
> --
> Live like a child, think like the god.
>
>



-- 
Regards,
GeunSik Lim
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
