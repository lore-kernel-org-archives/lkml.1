Return-Path: <linux-kernel-owner+w=401wt.eu-S1754336Ab0AZOYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab0AZOYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 09:24:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213Ab0AZOYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 09:24:33 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:47698 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab0AZOYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 09:24:32 -0500
From: Oliver Neukum <oliver@neukum.org>
To: felipe.balbi@nokia.com
Subject: Re: [RFC/PATCH 1/5] usb: otg: add notifier support
Date: Tue, 26 Jan 2010 15:24:49 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc3-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: ext David Brownell <david-b@pacbell.net>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>
References: <6ed0b2680912101251jeec28e6i216dfc51caab13aa@mail.gmail.com> <201001260535.21689.david-b@pacbell.net> <20100126141443.GE10690@nokia.com>
In-Reply-To: <20100126141443.GE10690@nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001261524.49661.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 26. Januar 2010 15:14:43 schrieb Felipe Balbi:
> >There are load bursting issues too.  All part of the USB spec;
> >a load that's OK for 1 millisecond might not be OK for 1 second.
> 
> if you get a SetConfiguration(config), then you can use that load for as 
> long as needed, the limitation is when not enumerated, afaict.

And when suspended.

	HTH
		Oliver
