Return-Path: <linux-kernel-owner+w=401wt.eu-S1764784AbYHFMRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764784AbYHFMRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 08:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759512AbYHFMRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 08:17:33 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:14345 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759331AbYHFMRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 08:17:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Ue0vszfZLyf1b5vF5N2bIZhfXmYJZH+xZbVio6nM8QPqfIjypao2aJpPJmk2kEtPXy
         6H7UJI80Bkubbcx8m9V6Ize8aNwLmgOSamryB4Yb/i2TamsKMtulmwdd4PFfxJhy2L3P
         SH/wMWw5ggCoTXF7lfmdYmsRmFJgnh73bc1q8=
Message-ID: <8bd0f97a0808060517m64d0d076r6cffc3f42963279e@mail.gmail.com>
Date: Wed, 6 Aug 2008 08:17:31 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: [PATCH] blackfin/sram: use 'unsigned long' for irqflags
Cc: "Bryan Wu" <cooloney@kernel.org>, "Julia Lawall" <julia@diku.dk>,
       "Alexey Dobriyan" <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <8bd0f97a0808060514x5c9ed37exbf8f9852b5a0b55d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080806105836.GA2903@localhost.localdomain>
	 <8bd0f97a0808060405qf70ead2t2f2604802875197e@mail.gmail.com>
	 <19f34abd0808060428m1c317531v4a58679c4051c0e9@mail.gmail.com>
	 <8bd0f97a0808060514x5c9ed37exbf8f9852b5a0b55d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 6, 2008 at 8:14 AM, Mike Frysinger wrote:
> On Wed, Aug 6, 2008 at 7:28 AM, Vegard Nossum wrote:
>> On Wed, Aug 6, 2008 at 1:05 PM, Mike Frysinger wrote:
>>> On Wed, Aug 6, 2008 at 6:58 AM, Vegard Nossum wrote:
>>>> From 3ef36948a88a968eec1b09859aa251dc6727df4e Mon Sep 17 00:00:00 2001
>>>> From: Vegard Nossum <vegard.nossum@gmail.com>
>>>> Date: Wed, 6 Aug 2008 12:00:23 +0200
>>>> Subject: [PATCH] blackfin/sram: use 'unsigned long' for irqflags
>>>>
>>>> Using just 'unsigned' will make flags an unsigned int. While this is
>>>> arguably not an error on blackfin where sizeof(int) == sizeof(long),
>>>> the patch is still justified on the grounds of principle.
>>>
>>> indeed, thanks
>>>
>>>> The patch was generated using the Coccinelle semantic patch framework.
>>>
>>> spam ?
>>
>> Hm? I'm sorry, I don't understand what you mean by that. Do you think
>> the credit is undeserved?
>
> *shrug* ... i dont see other patches with things like:
> The patch was generated with git.
> The patch was generated with eclipse.
> The patch was generated with emacs.
> etc...
>
> we dont generally list all of the tools in the log message that was
> used in *creating* a patch since it doesnt really add any value when
> looking back historically at changes.

although, such information may be fine in the region after --- where
the diffstat normally shows up as that will not go into the log ...
-mike
