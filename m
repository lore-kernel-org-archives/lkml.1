Return-Path: <linux-kernel-owner+w=401wt.eu-S1752389AbXEFQmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbXEFQmr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 12:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752905AbXEFQmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 12:42:47 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43394 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752276AbXEFQmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 12:42:46 -0400
Date: Sun, 6 May 2007 17:46:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Antonino Ingargiola" <tritemio@gmail.com>
Cc: "Oliver Neukum" <oliver@neukum.org>, "Paul Fulghum" <paulkf@microgate.com>,
       linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial
 possible bug]
Message-ID: <20070506174641.0e118546@the-village.bc.nu>
In-Reply-To: <5486cca80705060939v7ae1c9e2x9eeeb68c02956a33@mail.gmail.com>
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com>
	<1178381287.3379.8.camel@x2>
	<20070505173647.544f6707@the-village.bc.nu>
	<200705052007.16742.oliver@neukum.org>
	<20070505225241.54a5d01d@the-village.bc.nu>
	<5486cca80705060029p433c6acar22faaeced2d7da37@mail.gmail.com>
	<20070506132849.62e1e218@the-village.bc.nu>
	<5486cca80705060939v7ae1c9e2x9eeeb68c02956a33@mail.gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> To conclude, the store the *last* N bytes received seems a more
> reasonable policy for the input buffers managed by the kernel. If the

For your use maybe, but it is not the normal behaviour and it is not the
behaviour supported by hardware, which generally buffers the first few
bytes (and some things like Apple localtalk actually rely upon this)

> other policy is used (as tty does), then the kernel should flush all
> the buffers he *can* physically flush, remaining inside the host
> computer of course.

It certainly does no harm to try and do the job as best you can.
