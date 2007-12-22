Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbXLVP5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbXLVP5R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 10:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750884AbXLVP5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 10:57:06 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:56223 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751233AbXLVP5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 10:57:05 -0500
Date: Sat, 22 Dec 2007 16:56:08 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Remy Bohmer" <linux@bohmer.net>
Cc: "Andrew Victor" <linux@maxim.org.za>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       "Russell King" <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       kernel@avr32linux.org
Subject: Re: [PATCH v2 0/6] atmel_serial: Cleanups, irq handler splitup &
 DMA
Message-ID: <20071222165608.0dae1376@siona>
In-Reply-To: <3efb10970712191232t4e1a1148q2c634b004421a685@mail.gmail.com>
References: <1198077130-9021-1-git-send-email-hskinnemoen@atmel.com>
	<3efb10970712190757m18f8851cq54061ff109790805@mail.gmail.com>
	<20071219170935.4df62471@dhcp-252-066.norway.atmel.com>
	<3efb10970712190840m39876762yb4d31c36723c3b8a@mail.gmail.com>
	<20071219174742.68e70c6c@dhcp-252-066.norway.atmel.com>
	<3efb10970712190859j125eb027y89a967280c2c829@mail.gmail.com>
	<20071219181915.71e9daeb@dhcp-252-066.norway.atmel.com>
	<3efb10970712191232t4e1a1148q2c634b004421a685@mail.gmail.com>
Organization: Atmel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2007 21:32:44 +0100
"Remy Bohmer" <linux@bohmer.net> wrote:

> > We need to fix the break- and error handling though. But my vacation
> > starts tomorrow, so I probably won't be able to fix it until next
> > year.  
> 
> In that case, I wish you very good holiday, and a happy new-year.
> It was very pleasant working with you on this driver.

Thanks. It was a pleasure working with you too :-)

> I probably see you again on the list next year.

I think you can count on that. The oops fix needs to be folded into the
patchset somehow, so I'll probably send out a new series before it's
ready for merging (unless someone beats me to it.) We should probably
check if the DMA RX path needs the same treatment as well.

Haavard
