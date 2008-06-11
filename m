Return-Path: <linux-kernel-owner+w=401wt.eu-S1757631AbYFKW10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631AbYFKW10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 18:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753015AbYFKW1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 18:27:19 -0400
Received: from mail.gmx.net ([213.165.64.20]:58436 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752746AbYFKW1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 18:27:18 -0400
Content-Type: text/plain; charset="iso-8859-1"
Date: Thu, 12 Jun 2008 00:27:16 +0200
From: "Malte Cornils" <Malte.Cornils@gmx.net>
In-Reply-To: <1213221122.20453.26.camel@localhost>
Message-ID: <20080611222716.269180@gmx.net>
MIME-Version: 1.0
References: <1213221122.20453.26.camel@localhost>
Subject: Re: Lenovo ThinkCentre A55: parport_pc 00:0a: disabled;
  probe of	00:0a failed with error -22
To: linux-kernel@vger.kernel.org
X-Authenticated: #411139
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1+v4doY84yvcV6NkfmjvwCKuwP6YEhUOXWjwZT7rT
 JjDFj00RbVez3gSloGBXvz/k6MttfICRbeuQ== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: dmhjcBNdMmA6JWgqbWFnSoY5MjQ1Nx1F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again,

I wrote (yeah, why do I always find more info after posting?) minutes ago:
> dmesg says:
> [   40.935843] parport_pc 00:0a: disabled
> [   40.935850] parport_pc: probe of 00:0a failed with error -22
> 
> rmmod parport_pc ; modprobe parport_pc io=0x378 irq=none
> did not work either, the detection failed and echoing some bytes to
> the /dev/lp0 device fails, too.

attempting this, dmesg displays:
[  687.741109] parport 0x378 (WARNING): CTR: wrote 0x0c, read 0xff
[  687.741119] parport 0x378 (WARNING): DATA: wrote 0xaa, read 0xff
[  687.741122] parport 0x378: You gave this address, but there is probably no parallel port there!
[  687.741144] parport0: PC-style at 0x378 [PCSPP,TRISTATE]
[  687.838463] lp0: using parport0 (polling).


cat /sys/devices/pnp0/00:0a/resources
shows the resource as disabled. Even after
echo "auto" > ..resources
this remains so. 

> Something else:
> Lenovo provides a somewhat more recent BIOS[...]

Yeah - we finally were able to update the BIOS, unfortunately, it does not fix the bug.

Ok that's it for now,
again, I'd be happy for any pointers,
Yours
-Malte Cornils
-- 
Psssst! Schon vom neuen GMX MultiMessenger gehört?
Der kann`s mit allen: http://www.gmx.net/de/go/multimessenger
