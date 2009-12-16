Return-Path: <linux-kernel-owner+w=401wt.eu-S1755053AbZLPPsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053AbZLPPsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 10:48:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750840AbZLPPsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 10:48:23 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:49166 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbZLPPsW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 10:48:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=pzrNkH8jkUvl50BrWSV1uK+4tiIgC1JwzocllodmT1T9IyrtWTu8DmXmRkD/9Wnke9
         sAiE6cJE1tnv9Vzvw6EQMbz4e+dEv8dVd6UoyDGw5bftXOybOkpnCIiLOr8Lf0SbD2LL
         NlUbrieZ14XgfCzX96kJZNZ0sNP9I4mGEP3Nw=
MIME-Version: 1.0
In-Reply-To: <9F4C7D19E8361D4C94921B95BE08B81BA08D5A@zin33exm22.fsl.freescale.net>
References: <4B27D87D.5070908@gmail.com> <9F4C7D19E8361D4C94921B95BE08B81BA08D5A@zin33exm22.fsl.freescale.net>
From: roel kluin <roel.kluin@gmail.com>
Date: Wed, 16 Dec 2009 16:48:00 +0100
Message-ID: <25e057c00912160748x504cb4c1ibaa3ab6d26864525@mail.gmail.com>
Subject: Re: [PATCH] gianfar: Fix tests of unsigneds in gfar_parse_group()
To: Kumar Gopalpet-B05799 <B05799@freescale.com>
Cc: netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 6:04 AM, Kumar Gopalpet-B05799
<B05799@freescale.com> wrote:
>
>>Won't it be better to change types of interruptTransmit,
>>-Receive and -Error in  struct gfar_priv_grp itself. Something
>>like this:

> struct gfar_priv_grp {
> ....
> -       unsigned int interruptTransmit;
> -       unsigned int interruptReceive;
> -       unsigned int interruptError;
>
> +       int interruptTransmit;
> +       int interruptReceive;
> +       int interruptError;
> ....
> }
>
> --
>
> Thanks
> Sandeep

I don't think that's better. Only the error returned is signed,
If none occurred the irq thereafter is unsigned.

Thanks,

Roel
