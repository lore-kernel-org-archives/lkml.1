Return-Path: <linux-kernel-owner+w=401wt.eu-S934220AbXEESHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934220AbXEESHf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 14:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934248AbXEESHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 14:07:35 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:42603 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934220AbXEESHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 14:07:34 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial possible bug]
Date: Sat, 5 May 2007 20:07:15 +0200
User-Agent: KMail/1.9.1
Cc: Paul Fulghum <paulkf@microgate.com>,
       Antonino Ingargiola <tritemio@gmail.com>,
       linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com> <1178381287.3379.8.camel@x2> <20070505173647.544f6707@the-village.bc.nu>
In-Reply-To: <20070505173647.544f6707@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705052007.16742.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 5. Mai 2007 18:36 schrieb Alan Cox:
> > In the serial driver this usually just results in dropping
> > RTS to signal the remote end to stop sending. The serial
> > driver always immediately gives receive data to the tty buffering
> > without regard to the throttled state.
> > 
> > I would argue that cdc-acm should do the same as the serial driver.
> 
> This is a bug in cdc-acm really. It should not double buffer, but to be
> fair to the authors prior to the new tty buffering it *had* to do this.

Hi,

should I understand this so that, if tty_buffer_request_room() returns
less than requested, the rest of the data should be dropped on the
floor?

	Regards
		Oliver
