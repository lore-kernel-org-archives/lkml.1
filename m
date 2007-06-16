Return-Path: <linux-kernel-owner+w=401wt.eu-S1753739AbXFPIBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbXFPIBS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 04:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751138AbXFPIBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 04:01:11 -0400
Received: from khc.piap.pl ([195.187.100.11]:56956 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbXFPIBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 04:01:10 -0400
To: David Greaves <david@dgreaves.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Daniel Hazelton <dhazelton@enter.net>,
       Michael Gerdau <mgd@technosis.de>, Alexandre Oliva <aoliva@redhat.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
	<200706142049.41819.dhazelton@enter.net>
	<200706150825.15491.mgd@technosis.de>
	<200706150520.15086.dhazelton@enter.net>
	<46726793.1020206@dgreaves.com>
	<alpine.LFD.0.98.0706151004460.14121@woody.linux-foundation.org>
	<4672D648.7020700@dgreaves.com> <m37iq496z9.fsf@maximus.localdomain>
	<46738CD2.2080804@dgreaves.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 16 Jun 2007 10:01:06 +0200
In-Reply-To: <46738CD2.2080804@dgreaves.com> (David Greaves's message of "Sat, 16 Jun 2007 08:10:10 +0100")
Message-ID: <m3r6ocuy4d.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Greaves <david@dgreaves.com> writes:

>> How hard would it be to reprogramm the flash?
>
> The flash contains hashes signed by the companies private key.
>
> The kernel contains the public key. It can decrypt the hashes but the
> private key isn't available to encrypt them. So although you can put a
> new application onto the system, you can't create a signed hash to
> write to the flash.
>
> The kernel only runs the executable if the hash is valid.
> You can re-write the kernel to avoid this check - but the hardware is
> Tivoised -
> so you can't run it.

I read it: the flash contains everything from the bootloader to the
kernel and file system.
The bootloader contains the public key and checks if the kernel/fs
are ok. That includes calculating hashes and checking signatures.
No encryption/decryption there at all.

Right?

Then how hard would it be to reprogram the flash, to get rid of all
this crap? Or to just put your public key there.

Do they at least use BGA type of flash chips so you can't attach
a clip and have to use something more demanding?
-- 
Krzysztof Halasa
