Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbYGDWEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbYGDWEj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 18:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbYGDWE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 18:04:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49723 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752885AbYGDWE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 18:04:28 -0400
Date: Fri, 4 Jul 2008 22:46:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: alan@redhat.com, LKML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: pata_it821x completely broken
Message-ID: <20080704224636.352e4a7b@lxorguk.ukuu.org.uk>
In-Reply-To: <200807042339.02444.linux@rainbow-software.org>
References: <200807042153.56644.linux@rainbow-software.org>
	<20080704212204.7c94ca7c@lxorguk.ukuu.org.uk>
	<200807042339.02444.linux@rainbow-software.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It complains pretty loudly - something like 3 screens (with framebuffer at 
> 1024x768) of errors like this:

Interesting. I need to have a poke at that - it used to work fine but
I've not tested the 821x recently and the HPA code has changed. It
shouldn't be issuing HPA commands in the first place. Added to the TODO
list. The HPA is supposed to be cleared by the driver setup code but if
the newer firmware is faking it then I wonder what it does if we allow
the command through.

> It's BIOS v1.7.1.94, firmware 02093030. Haven't tried waiting for the rebuild 
> to complete. It will probably take ages for 400GB drives. I'll try with some 
> much smaller drives (something <1GB).

Thanks
