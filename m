Return-Path: <linux-kernel-owner+w=401wt.eu-S932250AbXHFIRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250AbXHFIRl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 04:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759436AbXHFIRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 04:17:33 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60915 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759182AbXHFIRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 04:17:31 -0400
Date: Mon, 6 Aug 2007 09:24:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Nathan Williams" <ngwilliams@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: MODULE_LICENSE usage
Message-ID: <20070806092455.2b2acbda@the-village.bc.nu>
In-Reply-To: <b4e196fa0708060053x65f0b1d3m50c62206cb65e016@mail.gmail.com>
References: <b4e196fa0708060053x65f0b1d3m50c62206cb65e016@mail.gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> After asking the FSF for advice and working through their FAQ, I've
> given permission for the binary library file to be used with the GPL
> source code and be re-distributed with it.

Only the copyright holder can give additional permissions for a piece of
code so for such a change you must have the permission of each copyright
holder of the code.

If you write all the GPL code you can give permission for it to be mixed
with a non-free library (creating a less free than GPL result) but you
didn't write all of the kernel.

You also dont make it clear if the library is code running on the PC or
is firmware. That may make quite a difference.

> I would like to know if I'm permitted to use MODULE_LICENSE("GPL") in my module.

Almost certainly not. If your module was GPL licensed there would be no
binary library file. 

> Additionally, I'm unsure of what is the meaning of
> 
> "GPL and additional rights"     [GNU Public License v2 rights and more]

It indicates code where the recipient and end user has additional
rights beyond the GPL. Your proposal is additional restrictions which is
different and not GPL compatible.

> Is it correct to say that my driver is licensed under GPL with
> additional rights to use the binary library file?

The kernel developers have not given you permission to link their code
with binary only codes so the answer is that if your code is any way a
derivative work of the kernel you have no ability to distribute the
work resulting from putting together kernel GPL code and the binary stuff
at all.


