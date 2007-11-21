Return-Path: <linux-kernel-owner+w=401wt.eu-S1758776AbXKUNfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776AbXKUNfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 08:35:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbXKUNfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 08:35:11 -0500
Received: from ns1.suse.de ([195.135.220.2]:35981 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976AbXKUNfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 08:35:09 -0500
From: Andreas Schwab <schwab@suse.de>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [KERNEL]: Avoid divide in IS_ALIGN
References: <20071120135607.GA18346@gondor.apana.org.au>
	<Pine.LNX.4.61.0711201625570.21839@chaos.analogic.com>
	<Pine.LNX.4.61.0711210800140.25473@chaos.analogic.com>
X-Yow: I will establish the first SHOPPING MALL in NUTLEY, New Jersey...
Date: Wed, 21 Nov 2007 14:35:07 +0100
In-Reply-To: <Pine.LNX.4.61.0711210800140.25473@chaos.analogic.com>
	(linux-os@analogic.com's message of "Wed\, 21 Nov 2007 08\:06\:36 -0500")
Message-ID: <jefxyzlo1g.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"linux-os (Dick Johnson)" <linux-os@analogic.com> writes:

> Executing this script.............
>
> cat <<EOF >/tmp/xxx.c
> #include <stdio.h>
>
> #define IS_ALIGNED(x,a)		(((x) % ((typeof(x))(a))) == 0)
> #define _IS_ALIGNED(x, a)	(((x) & ((typeof(x))(a) - 1)) == 0)
>
> int main()
> {
>     int i;
>     long p = 0x12345678;
>     for(i=1; i< 0x11; i++)
>         printf("Old = %d, new = %d\n", IS_ALIGNED(p, i), _IS_ALIGNED(p, i));

Alignment is only defined for powers of two.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
