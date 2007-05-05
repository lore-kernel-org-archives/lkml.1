Return-Path: <linux-kernel-owner+w=401wt.eu-S933572AbXEEQ6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933572AbXEEQ6P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 12:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933576AbXEEQ6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 12:58:15 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:50725
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933572AbXEEQ6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 12:58:14 -0400
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial
	possible bug]
From: Paul Fulghum <paulkf@microgate.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Antonino Ingargiola <tritemio@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <200705051846.57112.oliver@neukum.org>
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com>
	 <463CB429.6050201@microgate.com> <1178381287.3379.8.camel@x2>
	 <200705051846.57112.oliver@neukum.org>
Content-Type: text/plain
Date: Sat, 05 May 2007 11:56:26 -0500
Message-Id: <1178384186.3379.23.camel@x2>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-05 at 18:46 +0200, Oliver Neukum wrote:
> Am Samstag, 5. Mai 2007 18:08 schrieb Paul Fulghum:
> > I would argue that cdc-acm should do the same as the serial driver.
> 
> Has this been tested?
> If so we could reduce the complexity of the throtteling logic in the usb
> drivers.

Antonino is doing so now.

I think Alan nailed it: with the old tty buffering the extra
logic was required to avoid data loss. The new tty buffering
handles large blocks of data with no problem.

Removing this part of the throttle logic makes
the input flushing mechanism complete.

--
Paul


