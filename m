Return-Path: <linux-kernel-owner+w=401wt.eu-S1757231AbZHZKsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231AbZHZKsm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756772AbZHZKsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:48:42 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:50962 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660AbZHZKsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:48:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=MtWHJokaenDixpFbb6B1EnANUDpI0WybwL/VESfToDLympyFhqyjweSvWJ4mbC7RU8
         xf6ozt/46V+qtQZUW2X86fDasntcOcMfyiuj9jpOOa915hCFtdd9upYgunH8OrLcDoGQ
         3sgAsUkRwSRazemWKHZ0AliYGHSGTexe81e5w=
MIME-Version: 1.0
In-Reply-To: <20090825093423.GA12935@elte.hu>
References: <20090825083222.GC17692@elte.hu> <20090825084808.GA14003@elte.hu>
	 <1251190466.7261.12.camel@penberg-laptop>
	 <19f34abd0908250203h52257f52v306545a3d8890577@mail.gmail.com>
	 <1251191507.26351.0.camel@penberg-laptop>
	 <1251192069.15678.21.camel@pc1117.cambridge.arm.com>
	 <1251192415.26351.5.camel@penberg-laptop>
	 <1251192534.15678.29.camel@pc1117.cambridge.arm.com>
	 <84144f020908250231k30ff4e9do20856bd1291f418c@mail.gmail.com>
	 <20090825093423.GA12935@elte.hu>
Date: Wed, 26 Aug 2009 13:48:41 +0300
X-Google-Sender-Auth: 37a2207153403337
Message-ID: <84144f020908260348reec91f3v514317f039058d4d@mail.gmail.com>
Subject: Re: WARNING: kmemcheck: Caught 32-bit read from uninitialized memory 
	(f6f6e1a4), by kmemleak's scan_block()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 12:34 PM, Ingo Molnar<mingo@elte.hu> wrote:
>> On Tue, Aug 25, 2009 at 12:28 PM, Catalin
>> Marinas<catalin.marinas@arm.com> wrote:
>> >> Does this look OK to you?
>> >
>> > For the kmemleak.c part:
>> >
>> > Acked-by: Catalin Marinas <catalin.marinas@arm.com>
>>
>> Vegard? Ingo? The patch is based on tip/out-of-tree so it probably
>> should go to the kmemleak tree?
>
> I'm testing it currently - but yeah, i'd agree that it should go
> into the kmemleak tree, with a .32 merge date or so.

Ingo/Vegard, ACK/NAK? I don't want my amazingly good patch to end up
in /dev/null so can we just shove it in kmemleak.git?

                                  Pekka
