Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996AbYJ1RGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbYJ1RGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 13:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbYJ1RGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 13:06:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39578 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752424AbYJ1RGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 13:06:04 -0400
Date: Tue, 28 Oct 2008 17:06:05 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Helge Hafting <helge.hafting@aitel.hist.no>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.28-rc2 i/o error on /dev/ttyUSB0
Message-ID: <20081028170605.611c7759@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.0810280928320.3386@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0810261221350.3386@nehalem.linux-foundation.org>
	<4906F54A.7020909@aitel.hist.no>
	<alpine.LFD.2.00.0810280928320.3386@nehalem.linux-foundation.org>
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

> squarely in the "oops, kref's are screwed up" corner, and you should talk 
> to Alan about your particular USB dongle. I bet that bisection would just 
> show you one of the kref commits (eg 4a90f09b "tty: usb-serial krefs" or 
> maybe 7d7b93c14 "tty: kref the tty driver object"). 

Doesn't sound like krefs but does sound like the tty layer changes
somewhere.

Helge - can you get me an strace of this
