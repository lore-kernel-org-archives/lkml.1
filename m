Return-Path: <linux-kernel-owner+w=401wt.eu-S1759755AbXK1KLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759755AbXK1KLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 05:11:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755345AbXK1KLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 05:11:37 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40345 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755115AbXK1KLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 05:11:36 -0500
Date: Wed, 28 Nov 2007 10:07:59 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Marcel Holtmann <marcel@holtmann.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       "Linux/m68k" <linux-m68k@vger.kernel.org>
Subject: Re: m68k build failure
Message-ID: <20071128100759.4091399e@the-village.bc.nu>
In-Reply-To: <20071128110111.0c11fbfc@poseidon.drzeus.cx>
References: <20071127220723.e2e3d0b4.akpm@linux-foundation.org>
	<20071128094856.056c0a3f@poseidon.drzeus.cx>
	<Pine.LNX.4.64.0711281020350.29243@anakin>
	<Pine.LNX.4.64.0711281024351.29243@anakin>
	<20071128110111.0c11fbfc@poseidon.drzeus.cx>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Delightful. So what are the options here? Start packing the device table structs is the obvious quick fix. Declaring cross-compilation unsupported isn't really viable, and I guess determining padding differences is far from easy.

There are some ugly options:

Cross compile a test object containing nothing but

	struct whatever fred;

then dump it with the relevant cross nm

