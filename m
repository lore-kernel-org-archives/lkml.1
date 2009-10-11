Return-Path: <linux-kernel-owner+w=401wt.eu-S1752142AbZJKIXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbZJKIXr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 04:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795AbZJKIXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 04:23:47 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:54278 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbZJKIXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 04:23:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=wJY9/pRGdDqvA/PTAeRnNAwuOsgqCvp+HG1lmGVo/7ZD/rk/cciMlOw9yXvD98QoD4
         mhI+YsrgIvcPEwZxARwtRufgX4Q1z+B13mzcgc9FSS0lhnkTGuYBcbP0Hl8NJNDFmKs+
         MVTph+74bOjZ6sZTQS+ra5WO1FEWqbi+1lGi0=
MIME-Version: 1.0
In-Reply-To: <1255168333.25078.82.camel@ymzhang>
References: <1255153724.25078.68.camel@ymzhang>
	 <20091010080117.GN9228@kernel.dk> <1255168333.25078.82.camel@ymzhang>
Date: Sun, 11 Oct 2009 10:23:09 +0200
Message-ID: <4e5e476b0910110123s54debc6as435c9cc0d5e8340c@mail.gmail.com>
Subject: Re: fio rand read/write regression with 2.6.32-rc3
From: Corrado Zoccolo <czoccolo@gmail.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 10, 2009 at 11:52 AM, Zhang, Yanmin
<yanmin_zhang@linux.intel.com> wrote:
> On Sat, 2009-10-10 at 10:01 +0200, Jens Axboe wrote:
>> On Sat, Oct 10 2009, Zhang, Yanmin wrote:
>> > Comparing with 2.6.23-rc1's result, fio rand read write has regression
>> > on my 2*4 core stoakley machine (8GB memory) with a JBOD of 12 disks.
>> >
>> > Every disk has 8 1-GB files. Start 8 sub-processes per disk and every
>> > process random chooses a file on the disk to do 36 times of file read or
>> > write on the file and then choose another file.
>> >
>> >
>> > fio_mmap_rand_read_4k regresion is about 35%.
>>
>> Heh, I seem to recollect I told Linus that this would cost is 30-40%
>> performance. So not totally crazy.
>>
>> So yes, this isn't hugely unexpected. If you send me your fio job files,
>> I'll try and see what I can do about it.
> See the attachment.
>
Hi Yanmin,
the fio test you sent just performs random read, no write seems involved here.
I suspect that you should be able to observe the same regression if
you just run on a single disk. Can you confirm?
Is your disk a SATA2 rotational disk with NCQ?

Thanks,
Corrado

-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
