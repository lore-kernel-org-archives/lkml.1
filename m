Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab0BOGqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 01:46:36 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:38352 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab0BOGqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 01:46:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=pAicEWs9TTQeHkam9E3bdkBhSxfDOw39QYZXk/IYkyGddTjnxLf8x6p6RjIokkFfn5
         D9/5I7TFYuM6scwPWf4ueHhZrF712q94o/yIepwpzRdgifRg4tg8fqiK0qdWK3Ssgm3/
         nGK3UizeLrMyrgTG/Cta1slsU8/MQwDGv+bCY=
MIME-Version: 1.0
In-Reply-To: <dda83e781002142245l5c95d08bu214a796be289eb22@mail.gmail.com>
References: <dda83e781002141023t2abe95b8w83f59d6f411f68a2@mail.gmail.com>
	 <alpine.DEB.2.01.1002142229470.28195@bogon.housecafe.de>
	 <dda83e781002142245l5c95d08bu214a796be289eb22@mail.gmail.com>
Date: Sun, 14 Feb 2010 22:46:33 -0800
Message-ID: <dda83e781002142246i61737ae2j4fe7efb660b53d07@mail.gmail.com>
Subject: Re: reiserfs issue with 2.6.32.8
From: Bret Towe <magnade@gmail.com>
To: Christian Kujau <lists@nerdbynature.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 14, 2010 at 10:45 PM, Bret Towe <magnade@gmail.com> wrote:
> On Sun, Feb 14, 2010 at 10:39 PM, Christian Kujau <lists@nerdbynature.de> wrote:
>> On Sun, 14 Feb 2010 at 10:23, Bret Towe wrote:
>>> I recently attempted upgrading from 2.6.31.6 to 2.6.32.8 on a local server
>>> that runs several filesystems and when trying to move or copy or create a file
>>> on a reiserfs system that was sitting on lvm over raid5(not sure if
>>> that matters)
>>> I would get mv or cp to return Invalid Argument and not doing anything
>>> moving files from xfs to xfs worked fine tho
>>
>> I'm running 2.6.32 (and now 2.6.33) with reiserfs filesystems too and
>> cannot reproduce what you're seeing. Can you run mv/cp through strace and
>> provide the output? Also, if you can: maybe setting REISERFS_CHECK in your
>> kernel config might reveal something useful.
>>
>> Is this reproducible with 2.6.33-rcX as well? If so, I'd recommend to try
>> again with plain 2.6.32 and if it's still there, I see no other way to
>> narrow it down but with a git bisection (man git-bisect).
>
> I forgot to note that file operations on the reiserfs partitions
> worked fine inside themselves
>
> I guess I will see about running a few other kernels then over next
> few days as time permits
> first I will try is the reiserfs_check option tho then revert to .32
> and go from there
>

and I will also forget to hit reply all in the time being
