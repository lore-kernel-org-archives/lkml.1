Return-Path: <linux-kernel-owner+w=401wt.eu-S1755213AbYBYKXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbYBYKXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 05:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbYBYKXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 05:23:05 -0500
Received: from el-out-1112.google.com ([209.85.162.181]:43402 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbYBYKXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 05:23:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jMEjG87rn83tE+e04a319NpIV1xm8C5R2PvK70n1bujOjlOXpGkNdmLz5owAip6r+MJeWyg3NsiG4OLxgezOGcR1zp3hN5Xu1XDdIgkLBupDuEfK8lPZ4EHBsKsWJAjgQDs2NjT8NiB7OiiaJ4WXOjcbwh+MMTKpHasmdhMH8mY=
Message-ID: <f19298770802250223m29f001f5obb8a5dff48df836a@mail.gmail.com>
Date: Mon, 25 Feb 2008 13:23:02 +0300
From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Cc: "Pekka J Enberg" <penberg@cs.helsinki.fi>, "Michael Buesch" <mb@bu3sch.de>,
       "Ingo Molnar" <mingo@elte.hu>, "Alexey Zaytsev" <zaytsev.a@protei.ru>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <20080225064935.GA20997@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47BEAF3B.3080809@protei.ru> <200802241529.50967.mb@bu3sch.de>
	 <f19298770802240839w2c19fd52vb0d170359ba56fc5@mail.gmail.com>
	 <200802241816.01784.mb@bu3sch.de>
	 <Pine.LNX.4.64.0802250814450.10065@sbz-30.cs.Helsinki.FI>
	 <20080225064935.GA20997@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 9:49 AM, Greg KH <greg@kroah.com> wrote:
>
> On Mon, Feb 25, 2008 at 08:16:17AM +0200, Pekka J Enberg wrote:
>  > Hi Michael,
>  >
>  > On Sun, 24 Feb 2008, Michael Buesch wrote:
>  > > > The ony way I see this was possible, you manually changed the
>  > > > module loading order, so that the b43xx module was loaded prior
>  > > > to the ssb and b44 modules. Right?
>  > >
>  > > Right. So "so I'm left with either no wifi or no ethenet" being wrong.
>  >
>  > Lets make this simple: it used to work before and now it doesn't.
>  > Therefore it's a regression that must be addressed. Period.
>
>  Isn't the resolution Michael is suggesting is, "use the different driver"?
>

The b43 driver from 2.6.24 does not work with my hardware. The one from
2.6.25 seems to work, but 2.6.25 is far from being ready yet.

The only way you can get the old driver working in 2.6.24 is to
compile certain (completely unrelated for an outsider) drivers as
modules and play with the module loading order. I think this is a
bug, and it should be fixed in -stable.

And for 2.6.25, I think the patch should also be included, as the
bcm43xx driver is still there.


Btw, what are we discussing? The real bcm43xx maintainer
(Larry Finger) reviewed the patch and agreet it should go
into 2.6.24-stable and 2.6.25 . Now we only have to wait for
John Linville and Jeff Garzik to pick it up, right? If someone
still thinks the patch should not go in, he should at least
add them to the CC list. ;)



>  thanks,
>
>  greg k-h
>
