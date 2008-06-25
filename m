Return-Path: <linux-kernel-owner+w=401wt.eu-S1756393AbYFYBd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393AbYFYBd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 21:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754161AbYFYBc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 21:32:58 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:34683 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753935AbYFYBc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 21:32:57 -0400
Subject: Re: weird bug on r8169 with usb
From: Kasper Sandberg <lkml@metanurb.dk>
To: David CHANIAL <david.ml@euro-web.fr>
Cc: linux-kernel@vger.kernel.org, romieu@fr.zoreil.com
In-Reply-To: <200806250031.24804.david.ml@euro-web.fr>
References: <200806250018.37617.david.ml@euro-web.fr>
	 <200806250031.24804.david.ml@euro-web.fr>
Content-Type: text/plain; charset=ISO-8859-15
Date: Wed, 25 Jun 2008 03:31:25 +0200
Message-Id: <1214357485.701.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added cc to a person that might have some info

On Wed, 2008-06-25 at 00:31 +0200, David CHANIAL wrote:
> Le Wednesday 25 June 2008 00:18:37 David CHANIAL, vous avez écrit :
> > # dmesg | grep eth0 # without the bug
> 
> excuse my error (copy/paste error),
> without the bug, the output is :
> 
> # dmesg | grep eth0 # without the bug
> eth0: RTL8168c/8111c at 0xf8828000, 00:1e:8c:c4:66:7d, XID 3c2000c0 IRQ 18
> r8169: eth0: link up
> r8169: eth0: link up
> eth0: no IPv6 routers present
> 
> Note that i can boot without the usb devices
> eth0 is usable, i plug usb devices and eth0 continue to be fully usable.
> the bug occur only when i boot with the usb devices.

I believe this is not actually about usb, i've had some issues too (and
still have them) - look back a few months on lkml, you will find the
thread.

btw, sorry Francois for not coming back to you, but i sortof forgot
since the noapic thing works around it.

But i can confirm that 2.6.26 doesent fix it.

This bug seems to still hit lots of people.
> 
> Best regards,

mvh.
Kasper Sandberg

