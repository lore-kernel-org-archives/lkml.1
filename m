Return-Path: <linux-kernel-owner+w=401wt.eu-S1759291AbXH2Td5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291AbXH2Td5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 15:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754486AbXH2Tdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 15:33:47 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:15896 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651AbXH2Tdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 15:33:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=no5MXKVwckUDuC02U2Brr+OqhHC+N0sEGChTT2DbyUaLHQHoITewwCT7oM7Ov3DsVt/t2XbiBKCTjbF5JerGacy6rCYpqsO5hVksOnEsDI2rB9sCj11v+1lrhFhk7KGEaH7Lw5kfDs3oOg6lHI3TZ9S5zw9UJFBDPxj+UUpC/ks=
Message-ID: <9e4733910708291233h3c4022a9n6e46733c5c50e222@mail.gmail.com>
Date: Wed, 29 Aug 2007 15:33:43 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 4/5] Net: ath5k, license is GPLv2
Cc: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Jiri Slaby" <jirislaby@gmail.com>, linville@tuxdriver.com,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <20070829192858.75aa6542@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2713029743177393055@pripojeni.net>
	 <7515194658758617@pripojeni.net>
	 <20070828171155.GC29343@infradead.org>
	 <3208.1188408545@turing-police.cc.vt.edu>
	 <9e4733910708291101i3783a8b1l38f0d5cfb0c2863d@mail.gmail.com>
	 <20070829192858.75aa6542@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/29/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > > to remove the BSD/other license.   Jiri can release *his* code as GPLv2
> > > only, but I suspect the files as a whole really should be dual BSD/GPLv2,
> > > due to the numerous other stakeholders in those files.
> >
> > This mess has been occurring in the kernel for years. The DRM graphics
> > drivers are used in both BSD and Linux. It is quite easy to contribute
> > something to this code via LKML and think you are doing it under the
> > GPL. Doesn't a patch against the kernel have to be GPL? When these
> > patches get pulled back into BSD and distributed with it, did BSD get
> > infected with the GPL? AFAIK this has never been legally sorted out.
>
> I'm not aware anyone has felt it needed "sorting out". Its not exactly
> complicated.
>
>         BSD non advertising is compatible with GPL
>
> The GPL says:
>         "when you distribute the same sections as part of a whole which
>         is a work based on the Program, the distribution of the whole
>         must be on the terms of this License, "
>
> The BSD license doesn't conflict with that
>
> The GPL (and copyright law also say)
>
> "If identifiable sections of that work are not derived from the Program,
> and can be reasonably considered independent and separate works in
> themselves, then this License, and its terms, do not apply to ..."
>
> All a bit irrelevant anyway as Ath5K code (not the .h file) say:
>
>  * Alternatively, this software may be distributed under the terms of the
>  * GNU General Public License ("GPL") version 2 as published by the Free
>  * Software Foundation.
>
> So Jiri is choosing to distribute it under the GPL, and with his changes
> GPL only.
>
> So whats the problem ?

BSD code can definitely be brought into a GPL project as you describe.
The problem is the other direction.

Aren't patches made against the kernel GPL'd if the author doesn't
explicitly grant them more liberal BSD license in addition?

The problem then comes in taking the patches that were only made
available against GPL code and reshipping them under the BSD license
without the author explicitly agreeing to this.

What if a patch spans both code that is pure GPL and code imported
from BSD, how do you license it?

-- 
Jon Smirl
jonsmirl@gmail.com
