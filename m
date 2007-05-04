Return-Path: <linux-kernel-owner+w=401wt.eu-S1767712AbXEDW7D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767712AbXEDW7D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 18:59:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767768AbXEDW7C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 18:59:02 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:41882
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767712AbXEDW7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 18:59:00 -0400
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial
	possible bug]
From: Paul Fulghum <paulkf@microgate.com>
To: Antonino Ingargiola <tritemio@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-usb-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <5486cca80705041421y4fcaec01l7acafed1cea4b509@mail.gmail.com>
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com>
	 <5486cca80705040956g47f634ddp80d67038e8e3305a@mail.gmail.com>
	 <463B7534.6000207@microgate.com>
	 <5486cca80705041013pf481c2an9e639fc9285ba88e@mail.gmail.com>
	 <1178299247.3769.0.camel@amdx2.microgate.com>
	 <5486cca80705041025k46ccf716t8dcd1e6f29e2376e@mail.gmail.com>
	 <1178300493.3619.1.camel@amdx2.microgate.com>
	 <5486cca80705041146x5c5bda70s96ce74e389cc1635@mail.gmail.com>
	 <5486cca80705041206q3a077dedyedb5ac2fbf434ba8@mail.gmail.com>
	 <1178308173.3743.14.camel@amdx2.microgate.com>
	 <5486cca80705041421y4fcaec01l7acafed1cea4b509@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 04 May 2007 05:57:45 -0500
Message-Id: <1178276265.3417.3.camel@x2>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Antonino:

Can you try two tests (with my patch applied):

1. comment out the tty_flush_buffer() call in tty_ldisc_flush() and test

2. uncomment (reenable) the above call and comment out the
tty_flush_buffer() call in tty_ioctl() and test

Thanks,
Paul

