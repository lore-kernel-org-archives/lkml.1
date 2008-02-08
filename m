Return-Path: <linux-kernel-owner+w=401wt.eu-S933092AbYBHPOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933092AbYBHPOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 10:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757664AbYBHPOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 10:14:24 -0500
Received: from wx-out-0506.google.com ([66.249.82.227]:9467 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbYBHPOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 10:14:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Mzp0juxy8Q7AbMu4kD7jEdsEtfKfrNDZlNGBYGcBwo00QsuHuuntI1DE3l8IBAw9J2S5RGivoEKG9NXtKkzOgcHEHLYs5uizwL2grmleAYpHglQ8JFT82qQV6OTBiS9ORHe8J7QRXB0yDls5qGw1R4QgaaQAcTpp7PZHLVL38H0=
Message-ID: <b25c3fa70802080714m6236614i6b991dbb5d4aa20f@mail.gmail.com>
Date: Sat, 9 Feb 2008 00:14:17 +0900
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: "rohit h" <hrohit85@gmail.com>
Subject: Re: [LINUX-KERNEL] C++ in linux kernel
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <90d987c0802072121v378da809l7b2690980566cd9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <90d987c0802072121v378da809l7b2690980566cd9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/2/8, rohit h <hrohit85@gmail.com>:
> Hi,
>  I am a kernel newbie.
>  I tried to insmod a C++ module containing classes, inheritance.
>  I am getting 'unresolved symbol' error when I use the 'new' keyword.
>  What could the problem be?
>
>  What kind of runtime support is needed ( arm linux kernel)? Is a
> patch available for it?
>
>  Thanks,
> Rohit
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Rohit,
Please take a look at click modular router which is using c++ as a
linux kernel module.
http://www.read.cs.ucla.edu/click/
The lib/glue.cc provides custom operator new.

Thanks,
Joonwoo
