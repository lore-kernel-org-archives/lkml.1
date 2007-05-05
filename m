Return-Path: <linux-kernel-owner+w=401wt.eu-S933862AbXEEQcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933862AbXEEQcz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 12:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933860AbXEEQcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 12:32:55 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46447 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933895AbXEEQcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 12:32:54 -0400
Date: Sat, 5 May 2007 17:36:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Paul Fulghum <paulkf@microgate.com>
Cc: Antonino Ingargiola <tritemio@gmail.com>,
       linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial
 possible bug]
Message-ID: <20070505173647.544f6707@the-village.bc.nu>
In-Reply-To: <1178381287.3379.8.camel@x2>
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com>
	<1178299247.3769.0.camel@amdx2.microgate.com>
	<5486cca80705041025k46ccf716t8dcd1e6f29e2376e@mail.gmail.com>
	<1178300493.3619.1.camel@amdx2.microgate.com>
	<5486cca80705041146x5c5bda70s96ce74e389cc1635@mail.gmail.com>
	<5486cca80705041206q3a077dedyedb5ac2fbf434ba8@mail.gmail.com>
	<1178308173.3743.14.camel@amdx2.microgate.com>
	<5486cca80705041421y4fcaec01l7acafed1cea4b509@mail.gmail.com>
	<463BC223.2040304@microgate.com>
	<1178353618.3472.1.camel@x2>
	<5486cca80705050811k2903710y2bf9054434d8da4b@mail.gmail.com>
	<463CB429.6050201@microgate.com>
	<1178381287.3379.8.camel@x2>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> In the serial driver this usually just results in dropping
> RTS to signal the remote end to stop sending. The serial
> driver always immediately gives receive data to the tty buffering
> without regard to the throttled state.
> 
> I would argue that cdc-acm should do the same as the serial driver.

This is a bug in cdc-acm really. It should not double buffer, but to be
fair to the authors prior to the new tty buffering it *had* to do this.

Alan
