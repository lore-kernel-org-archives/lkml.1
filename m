Return-Path: <linux-kernel-owner+w=401wt.eu-S932288AbXGPWiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288AbXGPWiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 18:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757053AbXGPWhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 18:37:55 -0400
Received: from ik-out-1112.google.com ([66.249.90.180]:52260 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508AbXGPWhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 18:37:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=BV1f1G65vw/JKgyndipKs2kOlRitK2q6POnbR1zuJEOuzFHAqqTUgCY6PLFsFg0KQzTlKnwmU1kbxO2F0Q3lWQWKpbrOgFjjr1P3wUI7st1pIF5aJYh5tpiOhjJfUXxVvthjbPxxnXWhSbnU++gyBTRwcWwUaV3VPULFlV1yYAo=
Message-ID: <2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com>
Date: Mon, 16 Jul 2007 15:37:52 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Rene Herman" <rene.herman@gmail.com>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Cc: "Bodo Eggert" <7eggert@gmx.de>, "Matt Mackall" <mpm@selenic.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Jesper Juhl" <jesper.juhl@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       "David Chinner" <dgc@sgi.com>, "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <469BF104.1040703@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8FO1e-2jW-35@gated-at.bofh.it> <8Ghmx-60z-17@gated-at.bofh.it>
	 <8Gj55-hJ-5@gated-at.bofh.it> <8GkNo-2Vb-1@gated-at.bofh.it>
	 <8GtnN-7TG-23@gated-at.bofh.it> <8GVjY-PL-25@gated-at.bofh.it>
	 <E1IA7j1-0000j9-I3@be1.lrz> <469A5D7C.5010904@gmail.com>
	 <Pine.LNX.4.58.0707161523500.25779@be1.lrz>
	 <469BF104.1040703@gmail.com>
X-Google-Sender-Auth: 87e74cd11fab8d59
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/16/07, Rene Herman <rene.herman@gmail.com> wrote:
> Seeing as how single-page stacks are much easier on the VM so that creating
> those zillion threads should also be faster, at _some_ percentage we get to
> say "and now to hell with the rest".

This is the core dispute here. Stated differently, I hope you never
design a bridge that I have to drive over.

Correctness first, optimization second. Introducing random and
difficult to trace crashes upon an unsuspecting audience of sysadmins
and users is not a viable option.

If at some point one of the pro-4k stacks crowd can prove that all
code paths are safe, or introduce another viable alternative (such as
Matt's idea for extending the stack dynamically), then removing the 8k
stacks option makes sense.
