Return-Path: <linux-kernel-owner+w=401wt.eu-S1757243AbYAVVFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243AbYAVVFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 16:05:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbYAVVFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 16:05:47 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:59674 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbYAVVFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 16:05:45 -0500
Message-ID: <47965AA7.4080703@garzik.org>
Date: Tue, 22 Jan 2008 16:05:43 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Dan Nica <timi@crystal.rdstm.ro>
CC: linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: SiI 3512 Serial ATA Controller - kernel 2.6.23
References: <Pine.LNX.4.63.0801222230470.4758@crystal.rdstm.ro>
In-Reply-To: <Pine.LNX.4.63.0801222230470.4758@crystal.rdstm.ro>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Nica wrote:
> hello
> 
> I have a problem with a serial ata controller
> that uses a SiI 3512 chip.

A complete dmesg, complete lspci would be helpful.


> when I'm trying to add a device thats on the 3512 controller 
> to the array that I have, it give me lots of errors in dmesg
> like this:
> 
> ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x2400000 action 0x0
> ata3.00: BMDMA2 stat 0x8652001
> ata3.00: cmd 35/00:80:3f:5c:03/00:02:00:00:00/e0 tag 0 cdb 0x0 data 327680 
> out
>          res 51/04:80:3f:5e:03/00:00:00:00:00/e0 Emask 0x1 (device error)

That's the device reporting an error, when the system issued a WRITE 
command ("cmd 35/....."), and the SiI controller is happily reporting 
that error to you.

I would worry about the device, if it is reporting errors on WRITE.

	Jeff



