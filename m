Return-Path: <linux-kernel-owner+w=401wt.eu-S1758298AbXGILlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758298AbXGILlZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 07:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755379AbXGILkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 07:40:43 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:3383 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757935AbXGILkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 07:40:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=q8bKoI5idmQw7i+e/gTMPOZbigyZLg1AhWxA5MKE/XvSl2Y8zeWE4jFKRZwKzAbKEvmMNTlzlvlvjJZC9DvWK0/mTNmAnJTXPTD9vlBaS0bxUmlQwk017Dh/MhHkoxJgqll0y+hh8naEy2N4h4Cs/JMCa8AlC+5UPis1kY+EICM=
Message-ID: <cda58cb80707090440u1d320fc0u1cc04f95a443e226@mail.gmail.com>
Date: Mon, 9 Jul 2007 13:40:40 +0200
From: "Franck Bui-Huu" <vagabon.xyz@gmail.com>
To: "Ralf Baechle" <ralf@linux-mips.org>
Subject: Re: [2.6 patch] include/asm-mips/processor.h: "extern inline" -> "static inline"
Cc: "Adrian Bunk" <bunk@stusta.de>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070709102754.GB24487@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070707010330.GY3492@stusta.de>
	 <20070709102754.GB24487@linux-mips.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 7/9/07, Ralf Baechle <ralf@linux-mips.org> wrote:
> On Sat, Jul 07, 2007 at 03:03:30AM +0200, Adrian Bunk wrote:
>
> > "extern inline" will have different semantics with gcc 4.3,
> > and "static inline" is correct here.
>
> The idea was to have a linker error in case gcc should deciede for some
> reason not to inline this function which as I understand will continue
> to be the behaviour of gcc 4.3?
>

I don't know for this peculiar case but it usually is a good thing to
let gcc decide if the function needs to be inlined or not.

If we really want this function to be inlined in all cases, maybe we
should use __always_inline attribute instead ?

-- 
               Franck
