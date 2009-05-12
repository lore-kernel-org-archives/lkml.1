Return-Path: <linux-kernel-owner+w=401wt.eu-S1758738AbZELCIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738AbZELCIO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 22:08:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756652AbZELCHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 22:07:53 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:35124 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503AbZELCHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 22:07:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nia3O5+5r6r1oUOrvk6AiQ+mw0ayKoo8Bf7SIwdwj/B6r9j+g7EF5rokOLSXWbT0xd
         zK6hTak7FQdlYs/gHnK3jmTk7cVLSsenMGFT571xo/g1xz9Q7FAwnRa4OHp+vR+emhJf
         WIzGCzgLdOqxR2T3WT/The9NjA2GR7nkVa9ek=
MIME-Version: 1.0
In-Reply-To: <200905111850.01096.dmitry.torokhov@gmail.com>
References: <483a38b80905110441t703adbd6sab31bcf19b507fc9@mail.gmail.com>
	 <200905111850.01096.dmitry.torokhov@gmail.com>
Date: Tue, 12 May 2009 11:07:52 +0900
Message-ID: <483a38b80905111907v3a14fe56r7e565bc9a56a0342@mail.gmail.com>
Subject: Re: [PATCH 1/2] Input: tsc2007: fix locking method against the 
	current rc kernel
From: Kwangwoo Lee <kwangwoo.lee@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
       Trilok Soni <soni.trilok@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, May 12, 2009 at 10:50 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> Hi Kwangwoo,
>
> On Monday 11 May 2009 04:41:35 Kwangwoo Lee wrote:
>> Hi Dmitry,
>>
>> The following patch fixes bug in tsc2007.
>> It is not working correctly in the current rc kernels.
>> IMHO, this patch should go in the 2.6.30
>>
>
> I agree, it is in my for-linus branch now.
>
>> Can you advise me about "From: email" part?
>> I splited Thierry's patch. So the original "From: email" is followed:
>>
>> From: Thierry Reding <thierry.reding@avionic-design.de>
>>
>> Thank you,
>> Kwangwoo Lee
>>
>> From 749ee3a4a2c2fe1f41601481e47cb26d8ccec20d Mon Sep 17 00:00:00 2001
>> From: Kwangwoo Lee <kwangwoo.lee@gmail.com>
>
> This is the last "from" tag in the e-mail so my scripts picked that up.
> I adjusted the commit so now it shows Thierry as the original author.

That's good. Thanks.

-- 
Kwangwoo Lee <kwangwoo.lee@gmail.com>
