Return-Path: <linux-kernel-owner+w=401wt.eu-S1757543AbYG3UKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543AbYG3UKl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 16:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbYG3UKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 16:10:33 -0400
Received: from smtp.daktronics.com ([63.85.214.24]:4285 "HELO
	smtp.daktronics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750885AbYG3UKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 16:10:32 -0400
Subject: Re: map keyboard to stdin
From: Kevin Holland <khollan@daktronics.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.1.10.0807230050450.23410@fbirervta.pbzchgretzou.qr>
References: <1216760127.6242.18.camel@kevin-laptop>
	 <alpine.LNX.1.10.0807230050450.23410@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 30 Jul 2008 15:09:46 -0500
Message-Id: <1217448586.6245.16.camel@kevin-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2008-07-23 at 00:52 +0200, Jan Engelhardt wrote:
> On Tuesday 2008-07-22 22:55, Kevin Holland wrote:
> 
> >Hi all,
> >I have an embedded Linux board that uses 2.6.21, the console is output
> >the serial port.  How can I set it up so a USB keyboard will be accepted
> >as input as well as anything received from the serial port and it will
> >be echoed to the output of the serial port as well.  Basically I want to
> >issue commands either through a terminal program to the embedded board
> >or a USB keyboard that is connected to the board, but I still want to
> >see what was typed on the keyboard out the serial terminal. I have
> >enabled USB HID support in the Kernel as well.
> 
> Try booting with  console=tty0 console=ttyS0
> I am not sure whether this will accept input from both (that's for you 
> to test), though it definitely outputs to both.

This method doesn't seem to work on my setup since I'm only using the
serial port as the console, and have no frame buffer.  I can
cat /dev/input/event0 and get what appears to be scan codes when I press
keys on my keyboard.  How can I translate this into specific commands
for my serial console?

Thanks

Kevin
