Return-Path: <linux-kernel-owner+w=401wt.eu-S1755673AbZFPGlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbZFPGlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 02:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750902AbZFPGll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 02:41:41 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:16512 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbZFPGll convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 02:41:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hEgSrCaicb0ekVoFBI19wnTyAz2aN7TcOfvnxSEXod8ojsL6hqYFvxtTPN3z81fSu2
         THpYv8LNFGQNE0oyzR62W9DeUPxkf/El3hJkKlvkDq9/b5xDH3KOEEOjBqwEB6JryYxI
         8A9M26kewBosJvF+zwDI8a+4aN0eXMlvNXF58=
MIME-Version: 1.0
In-Reply-To: <20090616151628V.fujita.tomonori@lab.ntt.co.jp>
References: <20090614212018.GD20442@fluff.org.uk>
	 <4A356F0E.9020809@s5r6.in-berlin.de> <20090615081355.GA5139@amd.com>
	 <20090616151628V.fujita.tomonori@lab.ntt.co.jp>
Date: Tue, 16 Jun 2009 14:41:43 +0800
Message-ID: <d82e647a0906152341u57e170f7v41b6c6e5b9698211@mail.gmail.com>
Subject: Re: dma-debug: check_for_stack background?
From: Ming Lei <tom.leiming@gmail.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: joerg.roedel@amd.com, stefanr@s5r6.in-berlin.de, ben-linux@fluff.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/16 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>:
> On Mon, 15 Jun 2009 10:13:55 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
>
>> On Sun, Jun 14, 2009 at 11:43:42PM +0200, Stefan Richter wrote:
>> > Ben Dooks wrote:
>> >> On Sun, Jun 14, 2009 at 08:56:29PM +0200, Stefan Richter wrote:
>> >>> the DMA debug facility warns  about mappings of on-stack memory.
>> >>> What's the problem with that?
>> > ...
>> >> I'm not sure if it is possible on all architectures, however the
>> >> DMA mapping documentation prohibts the use of stack memory.
>> >
>> > Ah, it has all been documented in plain sight for ages.  Thanks for the
>> > pointer.
>>
>> Problem is that the stack might go away or could be otherwise reused
>> while the DMA is in-flight. This could cause really hard to debug
>> problems.
>
> Not true. Even if you use the stack buffer for DMA synchronously, it
> doesn't work (we had the bad code like starting dma and waiting for
> the completion).

Yes, there is cache alignement problem for stack buffer also.

>
> On some architectures, we can't use the stack buffer for DMA. That's
> why the DMA mapping documentation prohibits the use of stack memory
> for DMA.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Lei Ming
