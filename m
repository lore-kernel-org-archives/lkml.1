Return-Path: <linux-kernel-owner+w=401wt.eu-S1753469AbZDKAA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbZDKAA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 20:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751484AbZDKAAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 20:00:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47541 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751117AbZDKAAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 20:00:08 -0400
Date: Sat, 11 Apr 2009 01:00:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: MAX3100
Message-ID: <20090411010039.10d9d25d@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.0904100808350.4583@localhost.localdomain>
References: <20090408114427.28788.50640.stgit@t61.ukuu.org.uk>
	<alpine.LFD.2.00.0904100808350.4583@localhost.localdomain>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So I'm wondering if it would make sense to do a drivers/tty for the core 
> tty (ldisc, tty_io etc) stuff, and perhaps move some of the non-core 
> (serial) drivers into drivers/serial.
> 
> I don't know, for example, why drivers/char/stallion.c is not in 
> drivers/serial. Just historical reasons, or an actual reason?


drivers/serial is the stuff using the uart layer
drivers/usb/serial is the stuff using the USB serial layer
drivers/char is the stuff using neither

(plus exceptions and bits hiding in arch and stuff)

It probably will make sense as everything is slowly getting dragged
kicking and screaming to the point where all of these are a struct
tty_port with other stuff attached but for the moment its actually sort
of convenient to keep them apart.

Alan
