Return-Path: <linux-kernel-owner+w=401wt.eu-S932370AbZKXMk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370AbZKXMk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 07:40:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757920AbZKXMk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 07:40:56 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37520 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757977AbZKXMkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 07:40:55 -0500
From: Juergen Beisert <jbe@pengutronix.de>
Organization: Pengutronix - Linux Solutions for Science and Industry
To: linux-kernel@vger.kernel.org
Date: Tue, 24 Nov 2009 13:41:10 +0100
User-Agent: KMail/1.9.9
Cc: Otavio Salvador <otavio@ossystems.com.br>
References: <be7a9f3d0911191311p45d4438bg84d55234eacdd320@mail.gmail.com> <be7a9f3d0911240331n61637196gf243af4e607403ff@mail.gmail.com> <be7a9f3d0911240355s5a85545amb32d25a7df7e09f0@mail.gmail.com>
In-Reply-To: <be7a9f3d0911240355s5a85545amb32d25a7df7e09f0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911241341.11020.jbe@pengutronix.de>
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: jbe@pengutronix.de
Subject: Re: Vortex86SX: only works with irqpoll
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dienstag, 24. November 2009, Otavio Salvador wrote:
> Hello Juergen,
>
> On Tue, Nov 24, 2009 at 9:31 AM, Otavio Salvador
>
> <otavio@ossystems.com.br> wrote:
> > I'll take a look on the dmesg output and see if I see something
> > interesting :-)
>
> In fact I did find some interesting issues. First:
>
> PCI: Probing PCI hardware
> pci 0000:00:07.0: default IRQ router [17f3:6031]
> pci 0000:00:0a.0: BAR 0: address space collision on of device
> [0x0e2000-0x0e2fff]
> pci 0000:00:0a.0: BAR 0: can't allocate resource
> pci 0000:00:0a.1: BAR 0: address space collision on of device
> [0x0e3000-0x0e30ff]
> pci 0000:00:0a.1: BAR 0: can't allocate resource
> pci 0000:00:0b.0: BAR 0: address space collision on of device
> [0x0e0000-0x0e0fff]
> pci 0000:00:0b.0: BAR 0: can't allocate resource
> pci 0000:00:0b.1: BAR 0: address space collision on of device
> [0x0e1000-0x0e10ff]
> pci 0000:00:0b.1: BAR 0: can't allocate resource
> NET: Registered protocol family 2
>
> This is the same collision I have. Another interesting issue is that
> your disk is using the USB bus while mine uses IT821x.

Yes, our system starts from a fixed soldered USB based disk.

> Is your network working? mine does not (inside of Linux but does for
> tftp booting).

Based on a "RDC R6040 Fast Ethernet Adapter" and the kernel states:

[...]
r6040: RDC R6040 NAPI net driver,version 0.24 (08Jul2009)
[...]

Runs with NFS and without any 'irqpoll' trick. (here the modul: 
http://www.ssv-comm.de/en/products/esom2586.php)

jbe

-- 
Pengutronix e.K.                              | Juergen Beisert             |
Linux Solutions for Science and Industry      | Phone: +49-8766-939 228     |
Vertretung Sued/Muenchen, Germany             | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686              | http://www.pengutronix.de/  |
