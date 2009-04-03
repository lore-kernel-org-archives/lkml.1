Return-Path: <linux-kernel-owner+w=401wt.eu-S935126AbZDCUtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935126AbZDCUtl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 16:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757712AbZDCUtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 16:49:31 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:2009 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756339AbZDCUta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 16:49:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IiVxyIL6iEYuv+ISnOKLSjkIw0IESX+SfxxETFLEgwDKU/hkrPfbpLW0gPQ14b58eL
         aNsCgPNPvkpa93TkSiGcLur4U1igqAaH7PISK8f7miqvc+tqUOcL356lheYVFQs0piKp
         YO44lUyw10u/xXsi4ROmmdtC8powQj0b5j1yc=
MIME-Version: 1.0
In-Reply-To: <49D66E83.5070606@inria.fr>
References: <f3177b9e0904031302p8aef826u1874a8b9d9af0840@mail.gmail.com>
	 <49D66E83.5070606@inria.fr>
Date: Fri, 3 Apr 2009 13:49:27 -0700
Message-ID: <86802c440904031349v31f84f8anf082db7505e60387@mail.gmail.com>
Subject: Re: Off topic: Numactl "distance" wrong
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Chris Worley <worleys@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 3, 2009 at 1:16 PM, Brice Goglin <Brice.Goglin@inria.fr> wrote:
> Chris Worley wrote:
>> Sorry for an off topic, but I'm hoping somebody can point me in the
>> right direction of where to direct this question...
>>
>> I have an Opteron system where I've seen the HW diagrams, and each of
>> 4 sockets is directly connected (HT) to two other sockets, and two HT
>> hops away from a third (i.e. a simple square topology, no X in the
>> middle).
>>
>> Yet, "numactl --hardware" shows but one hop to each socket:
>>
>> # numactl --hardware
>> ...
>> node   0   1   2   3
>>   0:  10  20  20  20
>>   1:  20  10  20  20
>>   2:  20  20  10  20
>>   3:  20  20  20  10
>>
>> I know this is wrong.
>>
>> Who would be the right person (or list) to talk about this?
>>
>
> IIRC, the motherboard/BIOS is supposed to report numa distances through
> the PXM ACPI method. But I have never seen any opteron box do it
> properly. So you just get 10 for "local" and 20 for "remote". Some
> Itanium machines however report actual distances.

for x86 64 bit, we are copying SLIT table and save another copy.

could provide one /sys interface to make user could modify it...

YH
