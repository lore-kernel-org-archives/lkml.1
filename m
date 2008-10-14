Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbYJNEac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbYJNEac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 00:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbYJNEaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 00:30:23 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:39264 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbYJNEaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 00:30:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=rNoWTtkkHlRUN+acjDBr7wMH3NgPWxwVgAjX9HjhPoDPfilqJ/hxBYeY7Q3H/FrWLr
         I3qBM1NwrVMeO5RCWAxnNnRzGYeHwJETbE55VOGVzfduCWDouUl4PA1y5N3iZ7N24/YH
         3DbOqwvPXio68DeoRogmmoZ8+gx8rvGK2qOrU=
Message-ID: <19f34abd0810132130r524c252q3fb5c520c34cf51@mail.gmail.com>
Date: Tue, 14 Oct 2008 06:30:21 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Arkadiusz Miskiewicz" <a.miskiewicz@gmail.com>
Subject: Re: oops while booting with recent git kernel
Cc: "Yinghai Lu" <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200810121227.09114.a.miskiewicz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200810121227.09114.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 12, 2008 at 12:27 PM, Arkadiusz Miskiewicz
<a.miskiewicz@gmail.com> wrote:
>
> Not sure if it's worth to report this before all initial merges happen but
> here it is anyway.
>
> git kernel with latest commit:
> commit fd048088306656824958e7783ffcee27e241b361
> Date:   Sat Oct 11 13:23:48 2008 -0700
>
> booted on thinkpad z60m results with such oops:
> http://carme.pld-linux.org/~arekm/img_2325_small.png
>
> Config used:
> http://carme.pld-linux.org/~arekm/img_2325_small.config

Thanks for the report.

It seems to be an instance of this (known bad) code:
http://lkml.org/lkml/2008/9/4/386

So hopefully it will be fixed soon.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
