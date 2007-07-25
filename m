Return-Path: <linux-kernel-owner+w=401wt.eu-S1762303AbXGYO1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762303AbXGYO1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 10:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbXGYO1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 10:27:24 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38036 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059AbXGYO1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 10:27:23 -0400
Message-ID: <46A75DC7.5020609@garzik.org>
Date: Wed, 25 Jul 2007 10:27:19 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: bryan.wu@analog.com
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Blackfin update
References: <1185370235.9648.8.camel@roc-laptop>
In-Reply-To: <1185370235.9648.8.camel@roc-laptop>
Content-Type: multipart/mixed;
 boundary="------------030308050201060206090703"
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030308050201060206090703
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Bryan Wu wrote:
> Hi Linus,
> 
> Please pull Blackfin architecture updates from:
> 
>  master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git/ master
> 
> Bug fixing, code cleanup, anomaly handling update and GPIO API update.
> 
> serial, SPI, EMAC and RTC driver updating.
> 
> Bernd Schmidt (3):
>       Blackfin arch: fix bug which unaligns the init thread's stack and causes the current macro to fail.
>       Blackfin arch: Initialize the exception vectors early in the boot process
>       Blackfin arch: Load P0 before storing through it
> 
> Bryan Wu (5):
>       Blackfin arch: fix a compiling warning about dma-mapping
>       Blackfin arch: bug fixing, add missing BF533_FAMILY GPIO_PFx definition
>       Blackfin arch: add BF54x I2C/TWI TWI0 driver support
>       Blackfin SPI driver: Initial supporting BF54x in SPI driver
>       Blackfin SPI driver update:
> 
> Michael Hennerich (14):
>       Blackfin arch: store labels so we later know who allocated GPIO/Peripheral resources
>       Blackfin arch: add peripheral resource allocation support
>       Blackfin arch: Add label to call new GPIO API
>       Blackfin arch: fix PORT_J BUG for BF537/6 EMAC driver
>       Blackfin arch: Finalize the generic gpio support - add gpio_to_irq and irq_to_gpio
>       Blackfin arch: Advertise GENERIC_GPIO and remove duplicated GENERIC_CALIBRATE_DELAY
>       Blackfin arch: add error message when IRQ no available
>       Blackfin arch: Add PORT_J.High (needed for BF548-EZkit Touchscreen interrupts) - remove PORT_C.H
>       Blackfin arch: add missing gpio error handling to make sure we roll back requests in case one fails
>       Blackfin Ethernet MAC driver: fix bug Report returned -ENOMEM upwards (in case L1/uncached memory alloc fails)

Two suggestions:

1) I know it's a quite minor -- and OK -- change, but please do CC 
relevant subsystem maintainers when you update the drivers (like net 
drivers -> me).

2) Including a patch for review would be useful.  I use the attached 
script to generate the pull request emails that go to Linus.  Others, 
like Greg KH, post individual patches for review before sending upstream 
-- but I think the latter is probably a bit much for blackfin.

Cheers!

	Jeff




--------------030308050201060206090703
Content-Type: application/x-shellscript;
 name="mkmsg.sh"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="mkmsg.sh"

IyEvYmluL3NoCgojCiMgdXNhZ2U6IG1rbXNnIFticmFuY2hdIFtvdXRwdXQgdGV4dCBmaWxl
XQojCgpCUkFOQ0g9IiQxIgpURVhUX09VVD0iJDIiCgpQV0Q9YHB3ZGAKUkVQTz1gYmFzZW5h
bWUgJFBXRGAKCmVjaG8gIlBsZWFzZSBwdWxsIGZyb20gJyRCUkFOQ0gnIGJyYW5jaCBvZiIg
PiAkVEVYVF9PVVQKZWNobyAibWFzdGVyLmtlcm5lbC5vcmc6L3B1Yi9zY20vbGludXgva2Vy
bmVsL2dpdC9qZ2FyemlrLyRSRVBPLmdpdCAkQlJBTkNIIiBcCgk+PiAkVEVYVF9PVVQKZWNo
byAiIiA+PiAkVEVYVF9PVVQKZWNobyAidG8gcmVjZWl2ZSB0aGUgZm9sbG93aW5nIHVwZGF0
ZXM6IiA+PiAkVEVYVF9PVVQKZWNobyAiIiA+PiAkVEVYVF9PVVQKCmdpdCBkaWZmIC1NIC0t
c3RhdCAtLXN1bW1hcnkgbWFzdGVyLi4kQlJBTkNIID4+ICRURVhUX09VVAplY2hvICIiID4+
ICRURVhUX09VVApnaXQgbG9nIC0tbm8tbWVyZ2VzIG1hc3Rlci4uJEJSQU5DSCB8IGdpdCBz
aG9ydGxvZyA+PiAkVEVYVF9PVVQKZ2l0IGRpZmYgbWFzdGVyLi4kQlJBTkNIID4+ICRURVhU
X09VVAoK
--------------030308050201060206090703--
