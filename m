Return-Path: <linux-kernel-owner+w=401wt.eu-S1758263AbXK3TUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263AbXK3TUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 14:20:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbXK3TUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 14:20:38 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:64791 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbXK3TUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 14:20:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Wc8oG93bzXW/tnLpng/gx7Kk0GycFMtd1iISzut/odUw9O0biovV2wTh7g5F71gZOEGaywK+yLEbmerMLvAoHv+Yy6G6L0TdjI6vjqDN/D/T+KG3zrC/LwkqgC6Le3p/nU0BK95l2xL7M1arz1xLKK9WK/ZVAmOTlI/wAVq4x5A=
Message-ID: <75b57c110711301120r7deff435oc010229b2b84b6a8@mail.gmail.com>
Date: Fri, 30 Nov 2007 14:20:24 -0500
From: "Gerb Stralko" <gerb.stralko@gmail.com>
To: "Michael Tokarev" <mjt@tls.msk.ru>
Subject: Re: 2.6.23: does it supposed to work on an i486?
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org
In-Reply-To: <475059D6.2080900@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47504923.9030309@msgid.tls.msk.ru> <4750519C.2000907@zytor.com>
	 <475059D6.2080900@msgid.tls.msk.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, I applied the patch (in 2.6.23 it's
>  arch/i386/boot/pmjump.S,
> not
>  arch/x86/boot/pmjump.S,
> but that's minor) - still the same behavior, it still reboots
> instantly right when bootloader gave control to the kernel.
> So it must be something else.. ;)

It should be x86, they merged the i386 and x86_64 code into one arch
called x86.   Try it again and see if it works

Thanks,

- Jerry
