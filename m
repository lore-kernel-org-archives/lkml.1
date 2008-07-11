Return-Path: <linux-kernel-owner+w=401wt.eu-S1759698AbYGKPsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759698AbYGKPsl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 11:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbYGKPsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 11:48:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54381 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752841AbYGKPsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 11:48:31 -0400
Date: Fri, 11 Jul 2008 16:31:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Marian =?UTF-8?B?QWxkZW5ow7Z2ZWw=?= 
	<marian.aldenhoevel@mba-software.de>
Cc: linux-kernel@vger.kernel.org, Gilles Espinasse <g.esp@free.fr>
Subject: Re: Building a kernel for SiS55-based system. No, wait! It's a 
 Vortex86SX.
Message-ID: <20080711163103.6c2102a0@lxorguk.ukuu.org.uk>
In-Reply-To: <48777FB9.8090102@mba-software.de>
References: <4860959E.6020207@mba-software.de>
	<1214471767.48635e574384b@imp.free.fr>
	<48708724.6020904@mba-software.de>
	<25e301c8df53$6a525780$f9b5a8c0@pii350>
	<48777FB9.8090102@mba-software.de>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Patches included:
> 
>    http://www.dmp.com.tw/tech/Vortex86SX/patch-2.6.18-DMP.gz
> 
> The bottom line is that current kernels don't work, the last one I know that
> works is 2.6.18.. That is used in Debian Etch and I was able to confirm
> operation by booting that one.
> 
> I have since downgraded my build-system to use 2.6.18.3 and that runs
> fine on my hardware. So now I can set it all up any way I like directly
> from upstream sources. Hooray!
> 
> Thank you very much.
> 
> Maybe someone smarter than me can figure out what the actual problem is,
> when it was introduced since 2.6.18 and then presumeably fix it. Until
> then I think I can live OK with the kernel I have now.

So 2.6.18 works and 2.6.19 fails ? What is the failure that is observed.
My first thought would be FPU emulation as nobody uses it any more.

Alan
