Return-Path: <linux-kernel-owner+w=401wt.eu-S1754319AbXDTBEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319AbXDTBEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 21:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754385AbXDTBEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 21:04:38 -0400
Received: from wx-out-0506.google.com ([66.249.82.233]:1508 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319AbXDTBEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 21:04:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=K1xf7aJ773XUHTLk6dvZsQsA8dWfUG2+GOgGL4A8hw5yi4nxieuwOzcytTwRksZQzoxHCGKeYj+g1z2Dh3DsGU0Mcj45VeCCWz+s8BujzBPuoB4j7f9yd6GfRV5LWifxrL98fLM0fl+/l0Ezl3nzLSFqVaawpsrl6NZwnfhbReY=
Message-ID: <f2b55d220704191804g2d5b0d5fl762a411c3edae43d@mail.gmail.com>
Date: Thu, 19 Apr 2007 18:04:36 -0700
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: GPL-incompatible Module Error Message
Cc: chris@pcburn.com, linux-kernel@vger.kernel.org
In-Reply-To: <20070420003111.376a44d2@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4627EED5.6020800@pcburn.com>
	 <f2b55d220704191558i6deadc08q6aa07360cadaaccc@mail.gmail.com>
	 <20070420003111.376a44d2@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/19/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> The troll is back I see.

Troll, shmoll.  I call 'em like I see 'em.  As much as I like and
depend on Linux, and as much as I respect the contributions and the
ideals of the EXPORT_SYMBOL_GPL partisans, they're spreading needless
FUD by spraying "private-don't-touch-me" all over mechanisms that are
_explicitly_designed_ as interoperation boundaries.  They're also
aiding and abetting the FSF's hypocritical charlatanry about the
meaning of "derivative work".

> Why don't you give him some useful information instead

Alternate technical solutions are also useful.  You seem to know them;
I don't pretend to.  Thanks for providing them.

> - Turn off the paravirt option - you don't need it, and its just bloat
> and slows down the kernel. Then rebuild the kernel and other bits and it
> should all work fine.

Just out of curiosity -- it seems thoroughly unlikely that ATI has
intentionally touched paravirt_ops in fglrx.  Do you think that
redefining bog-standard Linux interfaces when CONFIG_PARAVIRT (or
whatever) is enabled suddenly makes fglrx a derivative work of
whatever code underlies paravirt_ops?

> The legality of the ati driver as a derivative work is another matter,
> but I don't see what _GPL symbols have to do with its legality beyond
> providing a hint.

Then surely you don't approve of spraying FATAL messages on people's
consoles under these circumstances.  Allowing code into one's kernel
whose integration problems can't or won't be diagnosed by mainline
developers may be foolish, but it's not FATAL.

Cheers,
- Michael
