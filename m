Return-Path: <linux-kernel-owner+w=401wt.eu-S1753469AbZFWHFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbZFWHFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 03:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbZFWHE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 03:04:57 -0400
Received: from mail-fx0-f224.google.com ([209.85.220.224]:53064 "EHLO
	mail-fx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbZFWHE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 03:04:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lco7suD8d/MNSFOMHG0mmk5pGlHh91HbHk662o5eTYR2vFtYvvOK8HYDTLq2VL68ZE
         gBBWKL8dpP26wqUykml4cnmoKpD4BjwEVpMqvAnHm2LcMuU0JFtFl80So0C+i6CDjboh
         82mhdVm8eLmvdSvsRPOiUeckKgzx15jAPtz4g=
MIME-Version: 1.0
In-Reply-To: <4A3FFE02.8020001@bluewatersys.com>
References: <4A3F017B.2010409@bluewatersys.com>
	 <63386a3d0906220122x31d0b23fk7bd86145b719d9b5@mail.gmail.com>
	 <4A3FFE02.8020001@bluewatersys.com>
Date: Tue, 23 Jun 2009 09:04:57 +0200
Message-ID: <63386a3d0906230004m66360f4fhbdc80c8e552a01d0@mail.gmail.com>
Subject: Re: [PATCH] SST25L (non JEDEC) SPI Flash driver
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       spi-devel-general@lists.sourceforge.net, mike@steroidmicros.com,
       linux kernel <linux-kernel@vger.kernel.org>, dedekind@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/22 Ryan Mallon <ryan@bluewatersys.com>:

> Out of curiosity: I'm not too clear on what makes a particular chip
> hot-pluggable. I think technically the sst25l chip could be put onto a
> hot-pluggable board or power domain. Can't most devices be made
> hot-pluggable? Is the general rule to make devices non hot-pluggable if
> most/all boards in the mainline do not allow it to be hot-plugged?

I haven't seen any rule about it, but nominally the drivers support the
configurations found in the kernel tree, so if some board physically
existing and soon-to-run linux hotplugs chips like this, then have it
__dev{init|exit} else __{init|exit} IMHO.

Of course you can design for all plausible use cases but it will pile up
indefinitely. Personally I try to not design software for a hardware until it
exists, and I like the IETF catch-phrase "rough consensus and running
code" and this sort of fits that :-)

Yours,
Linus Walleij
