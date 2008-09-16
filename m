Return-Path: <linux-kernel-owner+w=401wt.eu-S1753494AbYIPKy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbYIPKy2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 06:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbYIPKyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 06:54:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57200 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751961AbYIPKyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 06:54:18 -0400
Date: Tue, 16 Sep 2008 11:54:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mark Fortescue <mark@mtfhpc.demon.co.uk>
Cc: David Miller <davem@davemloft.net>, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
       joy@entuzijast.net
Subject: Re: Allow 8250 to work on sparc.
Message-ID: <20080916115400.31522d77@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.61.0809151934040.23817@mtfhpc.demon.co.uk>
References: <20080912.211854.102505246.davem@davemloft.net>
	<Pine.LNX.4.61.0809151507250.23201@mtfhpc.demon.co.uk>
	<20080915172211.6751bb17@the-village.bc.nu>
	<Pine.LNX.4.61.0809151934040.23817@mtfhpc.demon.co.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I am intrigued. Other than the valid baud rates what differences are 
> visible at the user level?

There are lots of variations between hardware of all kinds but the big
one with USB devices is generally latency.

> Yes, but I have not found a simple way to configure it to add serial port 
> devices to the next available /dev/ttyS<xx>. If this was the default, it 
> would be much easier for me :). (I am assuming that all the different 

That still isn't a kernel problem but a udev one and one for the udev
lists ?

Alan
