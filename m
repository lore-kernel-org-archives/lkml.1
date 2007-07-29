Return-Path: <linux-kernel-owner+w=401wt.eu-S935549AbXG2UX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935549AbXG2UX4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 16:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934266AbXG2UXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 16:23:47 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42189 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S934262AbXG2UXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 16:23:46 -0400
Date: Sun, 29 Jul 2007 21:30:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Hendrik ." <chasake@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Reading a bad sector does not report failure as 'read error'
 but hangs PC with 'Machine Check Exception'
Message-ID: <20070729213051.20ebc51e@the-village.bc.nu>
In-Reply-To: <626611.9154.qm@web52007.mail.re2.yahoo.com>
References: <46ACB357.4030006@shaw.ca>
	<626611.9154.qm@web52007.mail.re2.yahoo.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> How can I do this? I have installed mcelog but I
> cannot run it after the MCE error because the whole PC
> hangs. If I try it after a reboot with 'mcelog --k8
> --ascii' or whatever parameter, there is no output at

You could type error back in from the email ?

> Isn't it strange to say that the controller does
> something bad if there is just a bad sector on the
> drive that is reported and handled correctly in an
> older kernel 

Not really. Its very strange it gives an MCE at all but this is a known
failure path (and should be a fixed known failure path) for the Nvidia
SATA.
