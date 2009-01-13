Return-Path: <linux-kernel-owner+w=401wt.eu-S1757712AbZAMNsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712AbZAMNsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 08:48:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbZAMNrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 08:47:55 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53200 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752956AbZAMNry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 08:47:54 -0500
Date: Tue, 13 Jan 2009 13:48:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Mischa Jonker" <m.d.s.x.jonker@gmail.com>
Cc: "Jonker M.D.S.X." <nlv14114@e3.nl-htc01.nxp.com>,
       linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: pnx8xxx_uart: Fix break signal handling
Message-ID: <20090113134812.0ff43e4e@lxorguk.ukuu.org.uk>
In-Reply-To: <4142f31c0901130522n5273fb67j41cf1aaf7b32853c@mail.gmail.com>
References: <200901131109.n0DB9DRJ010712@pc67243907.ddns.nl-htc01.nxp.com>
	<20090113121135.5565b302@lxorguk.ukuu.org.uk>
	<4142f31c0901130522n5273fb67j41cf1aaf7b32853c@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This appears to be unrelated.
> >
> 
> Correct, you can look to it as two separate bugs:
> a) the next character is not ignored while it should;
> b) the status bits 31-8 are copied to the 'ch' variable while they shouldn't.
> 
> Both bugs prevent correct break signal handling (and therefore correct
> behaviour of the magic SysRq key). Bug b didn't cause too much trouble
> earlier because in most situations the status bits are all zero; for
> this case they unfortunately aren't.

Ok that makes sense - no need to split them.
