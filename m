Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbZI2MoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbZI2MoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 08:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbZI2Mn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 08:43:59 -0400
Received: from mail-px0-f194.google.com ([209.85.216.194]:45854 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038AbZI2Mnv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 08:43:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YkgG9gu7yanhZQ3znOEs0r1tpxFnkuCwjBXrrSyf7/VF5866k04rr1GjBfPJHtcmfg
         IDcQY40y6bzL4FPy7cTHkxKw41nWaXJTmI89uKA0VKQlerloINsW/X2+eLM93nCDt3rj
         7HhBNv2pRng0NwAjbZMx3/l6MA6aJnYXpEk9Y=
MIME-Version: 1.0
In-Reply-To: <20090929143729.5af8e1f8@infradead.org>
References: <f22d86810909290425s46406fe5ib00bcfc9673f70df@mail.gmail.com>
	 <20090929135925.50ac88bf@infradead.org>
	 <f22d86810909290516l4cdda2bav3588cc5f7d1f2f65@mail.gmail.com>
	 <20090929143729.5af8e1f8@infradead.org>
Date: Tue, 29 Sep 2009 18:13:55 +0530
Message-ID: <f22d86810909290543j587076c6if97696259f482268@mail.gmail.com>
Subject: Re: GFP_NOWAIT and GFP_NOMEMALLOC
From: "Leonidas ." <leonidas137@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 6:07 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> On Tue, 29 Sep 2009 17:46:35 +0530
> "Leonidas ." <leonidas137@gmail.com> wrote:
>>
>> The module is going to be a profiling module and the user module which
>> is under profiling
>> will call the apis which I am exporting. My apis will collect certain
>> data from point
>
> (I assume you are aware of 'perf' and such)
>
>
>> But frankly, I am not very familiar with Linux kernel apis yet hence
>> have resorted to
>> using a tree data structure for the first cut where I allocate memory
>> as needed depending on the context I am executing in. To optimize a
>> bit, I do not free my memory
>> till some threshold is reached.
>>
>> Some questions here:
>>
>> 1. GFP_NOWAIT as in kmalloc(size, GFP_KERNEL | GFPNOWAIT)?
>>
>> or
>>
>> kmalloc(size, GFP_NOWAIT), I know this one is a dumb one.
>
> don't do GFP_KERNEL |
>
> because that makes it basically equivalent to GFP_KERNEL, which is a
> sleeping version.
>
>>
>> 2. Any reference for the mempool kind of implementation mentioned
>> above?
>
> there's mm/mempool.c..
>
> as a general suggestion I would say "look at perf, and see if you can
> build on that, or borrow from it"...
>
>
> --
> Arjan van de Ven        Intel Open Source Technology Centre
> For development, discussion and tips for power savings,
> visit http://www.lesswatts.org
>

I will have a look at perf. Thanks for the inputs.

-Leo.
