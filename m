Return-Path: <linux-kernel-owner+w=401wt.eu-S1761454AbYENJ5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761454AbYENJ5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 05:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754936AbYENJ52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 05:57:28 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:51341 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbYENJ51 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 05:57:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=amhCCWVXGkjsqwnNowPHBQSmA3V+aBb2Uftsc+Uj7k5VQJz0icwmEeDFa4kR5+3ExAo/BIeVqyijptFT1PSB0UJc/CD1c4mvarPGCYuKDKagSj/jM+HdUpqiRG0g4wB2Tm8gtGmtUZG9djjyh+DaSerN9cvX84fwMtlemweKWzA=
Message-ID: <aa79d98a0805140257o1bf00647od1eecdf73695c76c@mail.gmail.com>
Date: Wed, 14 May 2008 13:57:24 +0400
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Andreas Schwab" <schwab@suse.de>
Subject: Re: m68k: main.c:(.init.text+0x730): undefined reference to `strlen'
Cc: "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Linux/m68k" <linux-m68k@vger.kernel.org>,
       "Linux Kernel Development" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <jeprrpth5m.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <Pine.LNX.4.64.0805140958400.5778@anakin>
	 <jeprrpth5m.fsf@sykes.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 12:37 PM, Andreas Schwab <schwab@suse.de> wrote:
> Geert Uytterhoeven <geert@linux-m68k.org> writes:
>
>  > My first guess is gcc is turning sizeof() into strlen() again.
>
>  Definitely not.  sizeof is a compile-time constant, strlen is not.  More
>  likely the strlen call is embedded in the expansion of strncat.
>
>  Andreas.
>
>  --
>  Andreas Schwab, SuSE Labs, schwab@suse.de
>  SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
>  PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
>  "And now for something completely different."
>

I've missed to add

#include <linux/string.h>

sorry, will make the patch today evening (or maybe someone could
make it). Thanks for report!
