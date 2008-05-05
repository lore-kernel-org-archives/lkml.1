Return-Path: <linux-kernel-owner+w=401wt.eu-S1759056AbYEEQHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759056AbYEEQHL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 12:07:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbYEEQG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 12:06:58 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56272 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753901AbYEEQG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 12:06:58 -0400
Date: Mon, 5 May 2008 16:57:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Dave Jones <davej@codemonkey.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: changeset: Make forced module loading optional
Message-ID: <20080505165736.5b31dc9f@core>
In-Reply-To: <alpine.LNX.1.10.0805051755460.11757@fbirervta.pbzchgretzou.qr>
References: <200805051455.02723.rusty@rustcorp.com.au>
	<alpine.LFD.1.10.0805042159230.32269@woody.linux-foundation.org>
	<alpine.LNX.1.10.0805050835450.11757@fbirervta.pbzchgretzou.qr>
	<20080505153230.GA25704@codemonkey.org.uk>
	<alpine.LNX.1.10.0805051755460.11757@fbirervta.pbzchgretzou.qr>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> trash grub in the MBR. No thanks, too much clouds. Also, it can't 
> possibly know how to call mkinitrd, because every distro has its own 
> stupid required flags (SUSE: requires none and tries to be smart, 

Of course it can - make install picks up distribution provided bits
beyond what is within the kernel scripting, and you can also use your own
scripts so make install does what you specifically want yourself.

Alan
