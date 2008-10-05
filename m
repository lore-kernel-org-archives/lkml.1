Return-Path: <linux-kernel-owner+w=401wt.eu-S1755882AbYJERSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882AbYJERSb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 13:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754001AbYJERSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 13:18:23 -0400
Received: from 1wt.eu ([62.212.114.60]:4621 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753777AbYJERSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 13:18:22 -0400
Date: Sun, 5 Oct 2008 19:18:18 +0200
From: Willy Tarreau <w@1wt.eu>
To: Klaus Ethgen <Klaus@Ethgen.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel freeze on 2.4.36.7
Message-ID: <20081005171818.GJ24654@1wt.eu>
References: <20081005154113.GA8387@ikki.ethgen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081005154113.GA8387@ikki.ethgen.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Klaus,

On Sun, Oct 05, 2008 at 04:41:16PM +0100, Klaus Ethgen wrote:
> Hello,
> 
> I use the stable kernel tree 2.4 and have reproduce the following bug
> with 2.4.36.2 and 2.4.36.7.
> 
> I got a new barcode scanner and plugged it into USB. The scanner works
> well until I remove it. In that second I get a trace and the kernel
> freeze.

Does it happen everytime you unplug it or only once in a while ? Also,
have you ever been running and older 2.4 kernel not causing this problem ?

> The message when I plug in the scanner:
>  hub.c: new USB device 00:1d.7-6.2, assigned address 5
>  input: USB HID v1.10 Keyboard [Weltrend Bar Code Reader] on usb1:5.0
> 
> The message when I unplug it:
>  Unable to handle kernel NULL pointer dereference at virtual address 00000048
>  ...

Does the same problem happen when you plug/unplug a USB keyboard on the
same machine ?

> Please pardon that I do not type the complete kernel dump as I know no
> way to log it to a text file in this case where the system freeze. But
> on request I can send the picture I made with my camera.

Yes, it would help a lot. That along with your kernel config and an
lsmod and dmesg outputs before the problem. Ideally, you should pass
the messages output through ksymoops with all modules loaded as before
the problem happens. If you want to more easily capture your messages,
you can connect another machine to your serial port and boot with
"console=ttyS0".

Regards,
Willy

