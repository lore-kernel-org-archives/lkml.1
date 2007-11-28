Return-Path: <linux-kernel-owner+w=401wt.eu-S1759519AbXK1KXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759519AbXK1KXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 05:23:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757071AbXK1KXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 05:23:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58889 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756089AbXK1KXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 05:23:32 -0500
From: Andreas Schwab <schwab@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Pierre Ossman <drzeus@drzeus.cx>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Marcel Holtmann <marcel@holtmann.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       "Linux/m68k" <linux-m68k@vger.kernel.org>
Subject: Re: m68k build failure
References: <20071127220723.e2e3d0b4.akpm@linux-foundation.org>
	<20071128094856.056c0a3f@poseidon.drzeus.cx>
	<Pine.LNX.4.64.0711281020350.29243@anakin>
	<Pine.LNX.4.64.0711281024351.29243@anakin>
	<20071128110111.0c11fbfc@poseidon.drzeus.cx>
	<20071128100759.4091399e@the-village.bc.nu>
X-Yow: ..Are we having FUN yet...?
Date: Wed, 28 Nov 2007 11:23:29 +0100
In-Reply-To: <20071128100759.4091399e@the-village.bc.nu> (Alan Cox's message
	of "Wed\, 28 Nov 2007 10\:07\:59 +0000")
Message-ID: <jer6ia3bz2.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

>> Delightful. So what are the options here? Start packing the device table structs is the obvious quick fix. Declaring cross-compilation unsupported isn't really viable, and I guess determining padding differences is far from easy.
>
> There are some ugly options:
>
> Cross compile a test object containing nothing but
>
> 	struct whatever fred;
>
> then dump it with the relevant cross nm

Everything would be much easier if all those driver_data members of the
device table structs would not be there.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
