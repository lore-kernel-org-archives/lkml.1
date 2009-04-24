Return-Path: <linux-kernel-owner+w=401wt.eu-S1755504AbZDXIsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504AbZDXIsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 04:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbZDXIsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 04:48:10 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:62068 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbZDXIsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 04:48:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=M3Vr2TqXO9LCLUsPf93ErxaC6NR+qE9D3K7vDDf4okNI4GMvdRqpPQMim5txtTNus3
         IsAZa0jdoue2YVg3oakWRqQ/EAU5Akc2+bZv1GmIrQhb/N3yyt4+hpQwvw7xUWv1+hQw
         sghUmbKk/tbmFOF3ElgVUFQXBa5GqdPK0u6B8=
MIME-Version: 1.0
In-Reply-To: <b647ffbd0904240146mdcb84f7mcefa0850da425155@mail.gmail.com>
References: <c4e36d110904170213q24c2688ag9bcaa8562dddaa3f@mail.gmail.com>
	 <20090423130930.50a6c9db.akpm@linux-foundation.org>
	 <b647ffbd0904240146mdcb84f7mcefa0850da425155@mail.gmail.com>
Date: Fri, 24 Apr 2009 10:48:08 +0200
Message-ID: <b647ffbd0904240148i52fd77b6j7ba3ee432170e6d@mail.gmail.com>
Subject: Re: WARNING: at fs/sysfs/group.c:138 sysfs_remove_group
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/24 Dmitry Adamushko <dmitry.adamushko@gmail.com>:
> 2009/4/23 Andrew Morton <akpm@linux-foundation.org>:
>> On Fri, 17 Apr 2009 11:13:08 +0200
>> Zdenek Kabelac <zdenek.kabelac@gmail.com> wrote:
>>
>>> Hi
>>>
>>>
>>> When I've checked  2.6.30-rc2 kernel and  I've got among other errors
>>> with Wifi message below.
>>> As I've noticed - some people were reporting this problem already earlier:
>>>
>>> http://www.gossamer-threads.com/lists/linux/kernel/1058276?page=last
>>>
>>> But for me - it started with 2.6.30-rc kernels.
>>> I've T61, 4GB, C2D, X86_64.
>>>
>>>
>>>
>>> Zdenek
>>>
>>>
>>> platform microcode: firmware: requesting intel-ucode/06-0f-0a
>>> platform microcode: firmware: requesting intel-ucode/06-0f-0a
>>
>> Lots of people are reporting this.  One person reported that each
>> attempt takes 60 seconds, thus delaying boot be several minutes.
>
> These microcode messages are normal per-se.
>
> From the original report [1] follows that there is another 60s. delay
> when loading a firmware for an eth device.

[1] http://marc.info/?l=linux-kernel&m=124032374206220&w=2


-- 
Best regards,
Dmitry Adamushko
