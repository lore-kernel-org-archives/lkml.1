Return-Path: <linux-kernel-owner+w=401wt.eu-S1764215AbXESVQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764215AbXESVQk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 17:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755568AbXESVQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 17:16:32 -0400
Received: from wx-out-0506.google.com ([66.249.82.239]:37638 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbXESVQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 17:16:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MYXKvMnFI4Gq2yGvpzPifCx/RFFv1gjHwYQi5+poKZM9FLrWf43q2KhnRNSTZHoPucJATGe9rZgQqUCawms1kn7L5ioj4UhUsA+O0FDBuiQnLHg5zZIn6KR046M1XoDKIHfl1KaCfdY59noGFcCsGHmi510GcfH1SL6q96jPXTU=
Message-ID: <b637ec0b0705191416w5ac36f2br66b29c237be32e5e@mail.gmail.com>
Date: Sat, 19 May 2007 23:16:31 +0200
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Benjamin Herrenschmidt" <benh@kernel.crashing.org>
Subject: Re: radeonfb and X800 cards
Cc: "Luca Tettamanti" <kronos.it@gmail.com>, "Daniel Drake" <dsd@gentoo.org>,
       "linux list" <linux-kernel@vger.kernel.org>, Jimmy.Jazz@gmx.net
In-Reply-To: <b637ec0b0705191333y63440c45ld8be4c02b2d329d7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <464BB43D.2020407@gentoo.org>
	 <1179367164.32247.256.camel@localhost.localdomain>
	 <20070517195958.GA6489@dreamland.darkstar.lan>
	 <b637ec0b0705171329i6da89fa8h655976e823aef41e@mail.gmail.com>
	 <1179451612.32247.329.camel@localhost.localdomain>
	 <b637ec0b0705191333y63440c45ld8be4c02b2d329d7@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, never mind. Of course it works.
I forgot to enable the framebuffer console, I thought that selecting a
fb driver would have automagically enabled it.

It breaks suspend-to-ram, but this is expected.

Thanks and sorry for the noise.
Fabio



On 5/19/07, Fabio Comolli <fabio.comolli@gmail.com> wrote:
> Hi.
> This patch does not work for me.
> Relevant part of the dmesg output is:
>
[snipped the rest of the email]
