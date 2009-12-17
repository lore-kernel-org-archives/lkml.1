Return-Path: <linux-kernel-owner+w=401wt.eu-S1764129AbZLQQbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764129AbZLQQbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 11:31:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760563AbZLQQa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 11:30:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:64934 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360AbZLQQaz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 11:30:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=THxhRnydRhbUdaXcyrCxZDyapoK3Y87pyoLMxWPUyPs0yod+lv1hQziSXlxY+94ZBs
         xBORdAy7nUUSUSDsIAobkDcukyz/eBaJ8CdiTfbopuLeXwNhZMPgrRLzOBhzYuwMYu3a
         ZSAROpeE28B2tLAxWaKoSnD1iGf/FfF17ohgY=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0912170816210.15740@localhost.localdomain>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	 <200912171618.32882.bzolnier@gmail.com>
	 <alpine.LFD.2.00.0912170726230.17868@localhost.localdomain>
	 <200912171708.07899.bzolnier@gmail.com>
	 <alpine.LFD.2.00.0912170816210.15740@localhost.localdomain>
Date: Thu, 17 Dec 2009 22:00:53 +0530
Message-ID: <4fb5db50912170830q70c7069ate6ccbc698073079f@mail.gmail.com>
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
From: Janakiram Sistla <janakiram.sistla@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
       Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 9:51 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Thu, 17 Dec 2009, Bartlomiej Zolnierkiewicz wrote:
>>
>> Well, it could have been done in the other way:
>>
>> -                     ret = sscanf (buf, "0x%lx - 0x%lx", &start_addr, &end_addr);
>> +                     ret = sscanf(buf, "0x%lx - 0x%lx",
>> +                                  &start_addr, &end_addr);
>>
>> Just an example that the limit itself is usually not a problem
>> but its literal interpretation is..
>
> What? Your version is no better.
>
> In the above case it doesn't matter, but I've had grep's that fail due to
> people splitting the actual string etc, which just drives me wild. We
> fixed that to allow checkpatch to skip those warnings, but the fact is,
> the fundamnetal problem has always been the "80 character" part.
>
> I don't think any kernel developers use a vt100 any more. And even if they
> do, I bet they curse the "24 lines" more than they curse the occasional
> 80+ character lines.
>
> I'd be ok with changing the warning to 132 characters, which is another
> perfectly fine historical limit. Or we can split the difference, and say
> "ok, 106 characters is too much". I don't care. But 80 characters is
> causing too many idiotic changes.
>
> There are way worse problems in many patches than long lines. Too complex
> expressions. Too deep indentation. Pure crap code. People seem to get way
> too hung up on ".. but at least it passes checkpatch".
>
I truely agree on this.It will better if we can change the warning for
100+ as suggested.This cleans the code alot infact.

-Ram
