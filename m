Return-Path: <linux-kernel-owner+w=401wt.eu-S1752142AbZGYEru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbZGYEru (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 00:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbZGYEru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 00:47:50 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:39946 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbZGYErt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 00:47:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=RFF32nXdflX2HvW3ohvqLzaKKmkwQ8aAO3/UoG74DGe8lhaevzgUkGte8Yu7qtUIJp
         RpI3EkHzlP68rR//uWcMg5JChW9sWZ0bqYBefbiK1zcfnsu4dzho/lvzfIw9N0YyvfhG
         rfaOLfgQt+Crl4f9Od5ppSh1/0xAr5X4nZZkI=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <49b7c2350905130806jc02a4dfg8b04ec2de4fb1ff4@mail.gmail.com>
References: <1242180268.31161.24.camel@centos51> <20090513113357.GA11773@hack>
	 <49b7c2350905130806jc02a4dfg8b04ec2de4fb1ff4@mail.gmail.com>
Date: Sat, 25 Jul 2009 06:47:47 +0200
Message-ID: <cfd18e0f0907242147h809b14qede7d4fbc200cc99@mail.gmail.com>
Subject: Re: [PATCH]man-pages : section 9 for kernel api description.
From: Michael Kerrisk <mtk.manpages@googlemail.com>
To: GeunSik Lim <leemgs1@gmail.com>
Cc: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       tovalds@linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Very late follow up here...

On Wed, May 13, 2009 at 5:06 PM, GeunSik Lim<leemgs1@gmail.com> wrote:
> Thank you for your opinion.
>
> 2009/5/13 Américo Wang <xiyou.wangcong@gmail.com>:
>> On Wed, May 13, 2009 at 11:04:28AM +0900, GeunSik Lim wrote:
>>>
>>>
>>>Dear Michael Kerrisk,
>>>
>>>Are you maintainer of man-pages(man-pages-3.XX.tar.gz)?
>>>I am not sure...
>>
>> Yes, he is.
>>
>>>
>>>I use fedora 9 distribution as Linux based Desktop OS currently.
>>>I have one proposal about "#> man <linux-kernel-api>" command.
>>>Can you tell me your opinion about below patch?
>>>Thanks reading.
>>>
>>>commit 45e950c98412c002c47254507a199731315c7c2b
>>>Author: GeunSik,Lim <leemgs1@gmail.com>
>>>Date:   Wed May 13 10:49:47 2009 +0900
>>>
>>>    Append Section 9 info of man command.
>>>
>>>    We view description of the Linux kernel API with man command.
>>>       For example,
>>>       Fedoar9#> yum install kernel-doc*
>>>       Fedora9#> man kobject_rename  or
>>>       Fedora9#> man kthread_create
>>
>> Why?
>> Why do you want kernel api doc be in man pages?
>> Why not just browsing the kernel source code?
>>
> I want Michael to append patch file  in the man-pages source that I
> sent because
> Many linux distributions (ex: Fedora , openSUSE, and so on ) already
> support  kernel api for man currently.
> In general, kernel api(ex:kernel-doc-2.6.29.1-30.fc10.noarch.rpm) is
> located in the
> /usr/share/man/man9/ directory when we installed linux distribution
> like Fedora by default.
> So, I think that we need description and section 9 folder(man9) in the
> man-pages source
> to understand  meaning of man 9.
>
>
>> Kernel APIs are not stable at all, this is also a reason why you
>> should not include their doc into man pages.
> I agree that Kernel APIs is not stable.
> But, I believe that we can utilize "#> man <linux-kernel-api>" command
> in the own
> Linux distribution easy to use about "uname -a" Linux kernel version.
> This support is a valuable. I think that The problem deserves solving.

I agree that there's a problem that needs solving here, but I don't
think it's one that can be solved by man-0pages, whose mission is to
document the kerenl-userpsace and libc APIs. (This doesn't mean that
kernel APIs couldn't be documented in man pages, but it would be a
different project.)

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Watch my Linux system programming book progress to publication!
http://blog.man7.org/
