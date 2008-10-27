Return-Path: <linux-kernel-owner+w=401wt.eu-S1752731AbYJ0Qf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbYJ0Qf6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 12:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750866AbYJ0Qfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 12:35:48 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57223 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750786AbYJ0Qfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 12:35:48 -0400
Date: Mon, 27 Oct 2008 16:35:18 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org
Subject: Re: [GIT PULL/RESEND] kernel message catalog patches
Message-ID: <20081027163518.50b6ddfb@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.0810270906520.3386@nehalem.linux-foundation.org>
References: <1224168620.9617.14.camel@localhost>
	<1224230354.4631.1.camel@localhost>
	<20081021092148.GB4980@osiris.boeblingen.de.ibm.com>
	<alpine.LFD.2.00.0810230835150.3287@nehalem.linux-foundation.org>
	<20081023210446.GA12003@osiris.boeblingen.de.ibm.com>
	<alpine.LFD.2.00.0810231433380.3287@nehalem.linux-foundation.org>
	<1225049195.14057.72.camel@localhost>
	<alpine.LFD.2.00.0810261212290.5200@nehalem.linux-foundation.org>
	<1225101688.15777.6.camel@localhost>
	<alpine.LFD.2.00.0810270750100.3386@nehalem.linux-foundation.org>
	<20081027160359.37db885c@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.0810270906520.3386@nehalem.linux-foundation.org>
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

> Which is why I think for something like this, it really needs to be 
> entirely outside. Because putting it inside the kernel simply isn't going 
> to result in anything really useful. Either it can be close to the message 
> and be updated reasonably (never mind that if we really do support 
> multiple languages, that's not going to happen anyway, even if it's 
> close), or it's going to be somewhere else and not be updated when changes 
> happen - and then it migth as well be a separate project.

Small bits of it have to be inside the kernel
- Markup (_("Hello") To extract the strings)
- To format the data in a way that can be recovered by ksyslogd and
translated.

Alan
