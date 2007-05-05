Return-Path: <linux-kernel-owner+w=401wt.eu-S934067AbXEEQrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934067AbXEEQrM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 12:47:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934069AbXEEQrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 12:47:11 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:34025 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934067AbXEEQrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 12:47:10 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Paul Fulghum <paulkf@microgate.com>
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial possible bug]
Date: Sat, 5 May 2007 18:46:56 +0200
User-Agent: KMail/1.9.1
Cc: Antonino Ingargiola <tritemio@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com> <463CB429.6050201@microgate.com> <1178381287.3379.8.camel@x2>
In-Reply-To: <1178381287.3379.8.camel@x2>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705051846.57112.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 5. Mai 2007 18:08 schrieb Paul Fulghum:

> If the line discipline throttles the driver input,
> the cdc-acm driver stops giving data to the tty buffering
> and instead stores them internally.

So do usb serial drivers.

> In the serial driver this usually just results in dropping
> RTS to signal the remote end to stop sending. The serial

This may take considerable time in the case of usb devices.

> driver always immediately gives receive data to the tty buffering
> without regard to the throttled state.
> 
> I would argue that cdc-acm should do the same as the serial driver.

Has this been tested?
If so we could reduce the complexity of the throtteling logic in the usb
drivers.

	Regards
		Oliver
