Return-Path: <linux-kernel-owner+w=401wt.eu-S1754389AbZA2Mxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbZA2Mxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 07:53:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751135AbZA2Mx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 07:53:29 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:36155 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbZA2Mx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 07:53:28 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: how to change serial device<->port association
Date: Thu, 29 Jan 2009 13:54:03 +0100
User-Agent: KMail/1.9.10
Cc: Pazzo Da Legare <pazzodalegare@gmail.com>, linux-kernel@vger.kernel.org
References: <1a26b4920901290302w5c9bb79cra29fda5e67cc96a4@mail.gmail.com> <alpine.LSU.2.00.0901291342050.15159@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LSU.2.00.0901291342050.15159@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901291354.04005.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Thursday 29 January 2009 13:43:02 schrieb Jan Engelhardt:
> >Serial: 8250/16550 driver $Revision: 1.90 $ 6 ports, IRQ sharing disabled
> >serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> >serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> >serial8250: ttyS2 at I/O 0x3e8 (irq = 4) is a NS16550A
> >serial8250: ttyS3 at I/O 0x2e8 (irq = 3) is a NS16550A
> >00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> >00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> >00:0b: ttyS2 at I/O 0x3e8 (irq = 10) is a NS16550A
> >00:0c: ttyS3 at I/O 0x2e8 (irq = 11) is a NS16550A
> >
> >I would like to change the map ttySx -> I/O port. I try with setserial
> >but it doesn't work....Any clue?

They are just names. Create device nodes with the name you like and
the correct major:minor combination. Udev can do this for you.

	Regards
		Oliver

