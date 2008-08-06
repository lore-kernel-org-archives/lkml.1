Return-Path: <linux-kernel-owner+w=401wt.eu-S1760730AbYHFL2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760730AbYHFL2m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 07:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764049AbYHFL2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 07:28:24 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:38870 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763293AbYHFL2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 07:28:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=RtPpbh2wIBf751pSO2ibwfnCwN/LjDcj0QFjZRewpCK7F0/SiN1dvmbo0XrPtkIfGW
         TllPT5MiYASSK7jXBheQm8tc61D59/0nGQdCz6Br80ONyvK65fQ4iRjkGtIigc33W5B6
         Y/jGNx/BfdnRcKlNU273zFblotwUHYkpHIPH4=
Message-ID: <19f34abd0808060428m1c317531v4a58679c4051c0e9@mail.gmail.com>
Date: Wed, 6 Aug 2008 13:28:22 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: [PATCH] blackfin/sram: use 'unsigned long' for irqflags
Cc: "Bryan Wu" <cooloney@kernel.org>, "Julia Lawall" <julia@diku.dk>,
       "Alexey Dobriyan" <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <8bd0f97a0808060405qf70ead2t2f2604802875197e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080806105836.GA2903@localhost.localdomain>
	 <8bd0f97a0808060405qf70ead2t2f2604802875197e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Aug 6, 2008 at 1:05 PM, Mike Frysinger <vapier.adi@gmail.com> wrote:
> On Wed, Aug 6, 2008 at 6:58 AM, Vegard Nossum wrote:
>> From 3ef36948a88a968eec1b09859aa251dc6727df4e Mon Sep 17 00:00:00 2001
>> From: Vegard Nossum <vegard.nossum@gmail.com>
>> Date: Wed, 6 Aug 2008 12:00:23 +0200
>> Subject: [PATCH] blackfin/sram: use 'unsigned long' for irqflags
>>
>> Using just 'unsigned' will make flags an unsigned int. While this is
>> arguably not an error on blackfin where sizeof(int) == sizeof(long),
>> the patch is still justified on the grounds of principle.
>
> indeed, thanks
>
>> The patch was generated using the Coccinelle semantic patch framework.
>
> spam ?

Hm? I'm sorry, I don't understand what you mean by that. Do you think
the credit is undeserved?

>
>> Cc: Julia Lawall <julia@diku.dk>
>> Cc: Alexey Dobriyan <adobriyan@gmail.com>
>> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
>
> should be CC Bryan Wu as well ...
> -mike
>

Oh right. I believed that Bryan Wu is the maintainer who would
eventually apply the patch, therefore I put him as a direct recipient
of the e-mail (To-field) and that he would add his Signed-off-by line
which would make the Cc-line redundant. I guess it makes some sense to
also list the maintainer in the patch Ccs since the patch itself may
be separate from the raw e-mail (e.g. in mail archives, which
generally don't display To: or Cc: fields). I didn't realize this
before.

Thanks.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
