Return-Path: <linux-kernel-owner+w=401wt.eu-S1754915AbZKQLH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915AbZKQLH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 06:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754700AbZKQLH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 06:07:29 -0500
Received: from mail-iw0-f178.google.com ([209.85.223.178]:50797 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843AbZKQLH2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 06:07:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=B5DpuoRuOmXis5kTsIzCEgC+uCf/ImQ9u26ihm241x6LDf5uEUWLMKrtwKnHwat3bZ
         QVGjLMHH2Cs1/irJhy+Gjz6MLr2Bq6t8yRTRDv6RJVnI1UR/r2oTOc4icrchecjufDsV
         E1TPTyw2CNYp/x4j5cA9eyaIG64+bRwfBdQAk=
MIME-Version: 1.0
In-Reply-To: <20091117015655.GA8683@suse.de>
References: <2df346410911151938r1eb5c5e4q9930ac179d61ef01@mail.gmail.com>
	 <20091117015655.GA8683@suse.de>
Date: Tue, 17 Nov 2009 19:07:33 +0800
Message-ID: <2df346410911170307y1eb1f209se01d0cf456bb0bc6@mail.gmail.com>
Subject: Re: [BUG]2.6.27.y some contents lost after writing to mmaped file
From: JiSheng Zhang <jszhang3@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

2009/11/17 Greg KH <gregkh@suse.de>:
>>
>> Tested kernel is 2.6.27.12 and 2.6.27.39
>
> Does this work on any kernel you have tested?  Or is it a regression?

I have tested on both 2.6.27.12 and 2.6.27.39, fsx-linux all failed.

>
>> Tested file system: ext3, tmpfs.
>> IMHO, it impacts all file systems.
>>
>> Some fsx-linux log is:
>>
>> READ BAD DATA: offset = 0x2771b, size = 0xa28e
>> OFFSET  GOOD    BAD     RANGE
> Are you sure that the LTP is correct?  It wouldn't be the first time it
> wasn't...

hmmm, I read the source again, IMHO it is correct.

>
> thanks,
>
> greg k-h
>

One more findings: If I add "return" at the beginning of domapwrite,
no fail found yet.

Regards,
Jisheng
