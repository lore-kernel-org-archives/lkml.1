Return-Path: <linux-kernel-owner+w=401wt.eu-S1757884AbZCTKBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884AbZCTKBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 06:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbZCTKBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 06:01:06 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41643 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751715AbZCTKBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 06:01:05 -0400
Date: Fri, 20 Mar 2009 10:01:46 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Robert Schwebel <r.schwebel@pengutronix.de>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       daniel.krueger@systec-electronic.com,
       Michael Olbrich <mol@pengutronix.de>, Wolfram Sang <wsa@pengutronix.de>,
       Marc Kleine-Budde <mkl@pengutronix.de>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: The Linux Staging tree, what it is and is not.
Message-ID: <20090320100146.6599f671@lxorguk.ukuu.org.uk>
In-Reply-To: <20090320005808.GM5367@pengutronix.de>
References: <20090318183232.GA11594@kroah.com>
	<20090320005808.GM5367@pengutronix.de>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> However, I'm still not convinced that this is the right way to go. What
> you want to do for the main APIs is provide some nice userspace library
> API for your applications. Why not put the whole "stack" into userspace
> then and connect it to the kernel only via raw socket.

- Security
- Compartmentalisation
- Sharing the device/interconnect
- Real time prioritisation

and a few others.

> What do others think? Is it worth the effort to invent a proper objdict
> API for linux?

Objdict appears to be a legacy wart and can stay where it belongs I
suspect - you might need to have a objdict -> 21st century conversion
library for the afflicted. We don't put specialised COBOL support in the
kernel either we let user space figure out how to cope with the funnies.

Alan
