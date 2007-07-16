Return-Path: <linux-kernel-owner+w=401wt.eu-S1761292AbXGPXNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761292AbXGPXNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 19:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbXGPXNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 19:13:25 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:26257 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbXGPXNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 19:13:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=GPdASEEFJLo7BZRaZXuzO/vKkFgWa7fsR7EWvKbH84mJ5DN2AMHjL0cR5rrjw4VH1vtt+Y5CL9ACkGLfi9BDa6m5Hoe58pRyk0+dKegDwwhc9Jp+ht+DjE/PMdi+Xxg3iyf6XEAo2ODyKfDRmekh62b76DOkywFY/YPw8pPMFUo=
Message-ID: <2c0942db0707161613lff9c07bpcf002b9139163a86@mail.gmail.com>
Date: Mon, 16 Jul 2007 16:13:22 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Rene Herman" <rene.herman@gmail.com>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Cc: "Bodo Eggert" <7eggert@gmx.de>, "Matt Mackall" <mpm@selenic.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Jesper Juhl" <jesper.juhl@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       "David Chinner" <dgc@sgi.com>, "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <469BF768.6040200@gmail.com>
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
	 <469BF768.6040200@gmail.com>
X-Google-Sender-Auth: 494fb4044c273761
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/16/07, Rene Herman <rene.herman@gmail.com> wrote:
> On 07/17/2007 12:37 AM, Ray Lee wrote:
> > If at some point one of the pro-4k stacks crowd can prove that all
> > code paths are safe
>
> I'll do that the minute you prove the current shared 8K stacks are safe. Do
> we have a deal?

Language barrier, I think, or perhaps I was unclear. Please read that
as "4k stacks introduce no new stack bugs." And if we put wli's
unconditional interrupt stacks into the kernel, it's pretty obvious
that 8k stacks are at least as safe in that case as 4k stacks.

Given that there's actual, y'know, reports of people who can easily
crash a 4k+interrupt stacks kernel, and not an 8k one, I think the
current evidence speaks for itself.

The point remains that the burden of proof of the safety of the 4k
only option is upon those people who want to remove the 8k option.
