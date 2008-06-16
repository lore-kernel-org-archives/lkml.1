Return-Path: <linux-kernel-owner+w=401wt.eu-S1758278AbYFPVvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278AbYFPVvn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 17:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755830AbYFPVvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 17:51:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36023 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753250AbYFPVvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 17:51:35 -0400
Date: Mon, 16 Jun 2008 22:34:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       jaswinder@infradead.org
Subject: Re: [PATCH] ip2: use request_firmware()
Message-ID: <20080616223402.6ad2365c@lxorguk.ukuu.org.uk>
In-Reply-To: <4856DDAA.1080707@garzik.org>
References: <1213609751.26255.673.camel@pmac.infradead.org>
	<20080616115950.41bc65aa@lxorguk.ukuu.org.uk>
	<4856C6C8.6060506@garzik.org>
	<4856C795.2050007@garzik.org>
	<20080616205820.1fe298d7@lxorguk.ukuu.org.uk>
	<4856CB61.6030202@garzik.org>
	<20080616212111.406f9c96@lxorguk.ukuu.org.uk>
	<4856DDAA.1080707@garzik.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> This separation certainly does not make things _easier_ for users, our 
> reason for existence.  This separation certainly does not make it easier 
> to drop in a driver with a firmware, i.e. not easier on driver 
> developers.  It is one more PITA detail when copying a driver from one 
> kernel to another, or shipping the driver out of tree.

Users run distributions. The user picture is "I installed it, it worked".

> There are good reasons why the Makefile rules, Kconfig rules, C source 
> code and headers for a driver all live together...  moving the firmware 

But they don't. Half the headers are in include/, random bits of glue are
scattered around the scripts dir.

> I like the goal, but see little effort in the area of "make this 
> transition painless for users."

I think we need to think about "for the technically competent and distro
builders". I don't see any connection between the choice of firmware
source directory and users at all. They typed make, magic occurred.

Alan
