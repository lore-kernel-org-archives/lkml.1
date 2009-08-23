Return-Path: <linux-kernel-owner+w=401wt.eu-S1755860AbZHWUtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbZHWUtU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 16:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbZHWUtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 16:49:19 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:54216 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbZHWUtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 16:49:19 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Bart Hartgers <bart.hartgers@gmail.com>
Subject: Re: New ark3116 driver - testers needed
Date: Sun, 23 Aug 2009 22:49:10 +0200
User-Agent: KMail/1.9.10
Cc: linux-usb@vger.kernel.org, ark3116_driver@auctionant.de,
       linux-kernel@vger.kernel.org
References: <7eb6a4d80908230546tc246dbdq33ffadcdce9a605a@mail.gmail.com>
In-Reply-To: <7eb6a4d80908230546tc246dbdq33ffadcdce9a605a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908232249.12914.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 August 2009 14:46:16 Bart Hartgers wrote:
> Hi All,
>
> I managed to write an improved ark3116 driver after I figured out that
> it is just an 16450 UART with some USB glue logic.
>
> Compared to the old ark3116 driver it offers the following improvements:
> - cts/rts handshake support
> - break signalling
> - line error detection
>
> Since it is a big step from the previous driver, it made little sense
> to modify that one, so I created new driver, named ark316new. Also
> this means that both could coexist if the new one doesn't work for
> someone.
>
> I have no datasheet, so the driver is entirely based on reverse
> engineering, and some testing by others would be a good idea.
>
> I also tried to include the IrDA fixes for the old ark3116.c driver
> that were posted on this list recently, but I could not test if
> these work, since I don't have the proper hardware.
>
> Because of this, I would appreciate reports of both success and
> failure in using this driver.

Good work. I'll try the driver during the week with that USB-to-IrDA thing.


Added LKML to CC.

-- 
Ondrej Zary
