Return-Path: <linux-kernel-owner+w=401wt.eu-S1755160AbXIQOSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160AbXIQOSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 10:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174AbXIQOSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 10:18:05 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:48735 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbXIQOSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 10:18:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ad9aDr1EukdT37hVHfosGOOMVmpk8ndr6UzKSAnpT31h/9mxwTx5GJtC82lj8x0+ZvCedJe2jfUN7iN3BUJNftHt2fC6Dmd3yboHdg0gZR+Nd9gf5SUzhzYzPV9pGT+tSNZ0I5PmH7nvcgqdM4nIlEmIceb5XpzoYE8yx4GoiO4=
Message-ID: <d9def9db0709170717t1aeb9bf5t38182bb6bbef816c@mail.gmail.com>
Date: Mon, 17 Sep 2007 16:17:59 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: Ram <vshrirama@gmail.com>
Subject: Re: Floating point computations in kernel modules
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <8bf247760709170706j6025bb14k8ab28f9467972c76@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8bf247760709170706j6025bb14k8ab28f9467972c76@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 9/17/07, Ram <vshrirama@gmail.com> wrote:
> Hi,
>
>    I am trying to write a driver which uses double, float. I am using
> an arm11 with gcc 3.4.4
>
>    When i try to compile my modules (with float variables) i get the error
>
>    WARNING: "__extendsfdf2" undefined!
>    WARNING: "__mulsf3"undefined!
>    WARNING: "__fixsfsi"undefined!
>    WARNING: "__floatsisf"undefined!
>
>    Can we use float, double in kernel modules?.
>

in general you shouldn't use floating point in the kernel since there's no
portable way which will work among different architectures.

>   Obviously it is a linking error, I am using soft-float. I tried with
> -msoft-float but got the same   result.
>
>   I suspect that its a toolchain issue.  However i am able to compile
> my applications
>   with float, double variables.
>
>
>   Please do advice.
>

if you need a solution inkernel best would be to try to get around by converting
your algorithm to integer.

although you might have a look at:
http://www.fi.muni.cz/~xslaby/unpr.html
http://www.mail-archive.com/linuxppc-embedded%40ozlabs.org/msg01291.html

Markus
