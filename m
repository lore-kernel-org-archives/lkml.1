Return-Path: <linux-kernel-owner+w=401wt.eu-S1755839AbXKLUvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839AbXKLUvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 15:51:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbXKLUu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 15:50:58 -0500
Received: from nz-out-0506.google.com ([64.233.162.234]:35685 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbXKLUu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 15:50:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Sg5jufpw1INlpe3+bw+rxLtq2UOPD2YAH2e6zN5CQjk6+1Ojy0w1K+nkgctbK30e6C4SsHMd5rrBiY+RBFCIMCio9IyH+lnxtu/sL7gW6Ujo/Fk7HIarRSWfHLCbq1e3Jl8yazv/j13DSEW4YwxgLTQ5WUOkeil62ilLj9lTOnA=
Message-ID: <8bd0f97a0711121250m63466b55u26184f31b2984328@mail.gmail.com>
Date: Mon, 12 Nov 2007 15:50:55 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: [PATCH] Include header required for INT_MAX
Cc: axboe@kernel.dk,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Christoph Hellwig" <hch@infradead.org>
In-Reply-To: <Pine.LNX.4.64.0711112349580.15517@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0711112349580.15517@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 11, 2007 5:52 PM, Jan Engelhardt <jengelh@computergmbh.de> wrote:
> >> Nack, we shoiuld never include userspace headers in kernel headers,
> >> an even more never add !__KERNEL__ ifdefs.  Just make sure your
> >> programs include limit.h before including linux/cdrom.h.
> >
> >I think header files should be complete, and should not use undefined
> >macros, picking up every random definition that may be in effect when
> >the header is included, don't you agree?
>
> No, because I be damn sure that some developers try compiling programs
> in non-linux environments (cygwin, solaris, andyourpersonaldistro, you
> name it) which do not have to adhere to <limits.h>. It might use
> <cosmiclimits.h> instead, or whatever.
> Hence, such extra includes are a nogo.

why are non-linux environments even relevant to the discussion ?
we're talking about fixing up a *linux header* file, so anyone doing
"#include <linux/cdrom.h>" in a non-linux environment is just stupid.

if yourpersonaldistro is a pos and doesnt provide a POSIX compliant
limits.h, then that distro is garbage and should be deleted and have
no bearing whatsoever on the direction of linux.
-mike
