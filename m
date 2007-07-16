Return-Path: <linux-kernel-owner+w=401wt.eu-S1755048AbXGPWxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048AbXGPWxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 18:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbXGPWxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 18:53:32 -0400
Received: from ik-out-1112.google.com ([66.249.90.180]:56757 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbXGPWxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 18:53:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Xo52KAO1VAo3/nv4bgV6fx1nQkIK+vaegeOeOmL1dJ0bbyrZFb5Udi2fckfyebucs5P8xqp/h46G8G+ey6IOsKVuEOEQHhydDq3r1au38HJ3ySpIn1rJUSeYJGzqlAvrGtVi46ZuTId1hFDU6hV/txvqr3IhmuVhuoqk9L/Cp4k=
Message-ID: <2c0942db0707161553u5d55724u82424b3ffbbd79f7@mail.gmail.com>
Date: Mon, 16 Jul 2007 15:53:29 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Cc: "Rene Herman" <rene.herman@gmail.com>, "Bodo Eggert" <7eggert@gmx.de>,
       "Matt Mackall" <mpm@selenic.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Jesper Juhl" <jesper.juhl@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       "David Chinner" <dgc@sgi.com>, "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <20070716235438.1bdd0722@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8FO1e-2jW-35@gated-at.bofh.it> <8GkNo-2Vb-1@gated-at.bofh.it>
	 <8GtnN-7TG-23@gated-at.bofh.it> <8GVjY-PL-25@gated-at.bofh.it>
	 <E1IA7j1-0000j9-I3@be1.lrz> <469A5D7C.5010904@gmail.com>
	 <Pine.LNX.4.58.0707161523500.25779@be1.lrz>
	 <469BF104.1040703@gmail.com>
	 <2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com>
	 <20070716235438.1bdd0722@the-village.bc.nu>
X-Google-Sender-Auth: a0dc16402d250f20
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/16/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > If at some point one of the pro-4k stacks crowd can prove that all
> > code paths are safe, or introduce another viable alternative (such as
> > Matt's idea for extending the stack dynamically), then removing the 8k
> > stacks option makes sense.
>
> Any x86-32 path unsafe with 4K stacks is almost certainly unsafe with 8K
> stacks because the 8K stacks do not have seperate IRQ stack paths, so you
> have the same space but split. It might be less predictable on 8K stacks
> but it isn't absent.

Understood, but isn't that an argument pro interrupt stacks, rather
than one against 8k? wli has a patch to break out the interrupt stack
feature from the 4k/8k choice.
