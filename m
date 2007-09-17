Return-Path: <linux-kernel-owner+w=401wt.eu-S1756082AbXIQONz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082AbXIQONz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 10:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754172AbXIQONr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 10:13:47 -0400
Received: from pat.uio.no ([129.240.10.15]:51574 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154AbXIQONr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 10:13:47 -0400
Subject: Re: Floating point computations in kernel modules
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Ram <vshrirama@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <8bf247760709170706j6025bb14k8ab28f9467972c76@mail.gmail.com>
References: <8bf247760709170706j6025bb14k8ab28f9467972c76@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 17 Sep 2007 10:13:43 -0400
Message-Id: <1190038423.6700.17.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=0.1, required=12.0, autolearn=disabled, AWL=0.098)
X-UiO-Scanned: 18A67A01D8EBE4CED395FF2863997A291E35810A
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 1 maxlevel 200 minaction 2 bait 0 mail/h: 414 total 3924776 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-17 at 19:36 +0530, Ram wrote:
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
> 
> Regards,
> sriram
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Feel free to peruse the Documentation directory before posting. More
specifically, Documentation/DocBook/kernel-hacking.tmpl has a chapter
called 'Some Basic Rules' which addresses your question.

Trond

