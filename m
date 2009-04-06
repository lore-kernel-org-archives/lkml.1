Return-Path: <linux-kernel-owner+w=401wt.eu-S1755937AbZDFJPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbZDFJPZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 05:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755179AbZDFJPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 05:15:11 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56262 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755149AbZDFJPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 05:15:10 -0400
Date: Mon, 6 Apr 2009 10:16:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: USB: symbolserial: log the ioctl commands
Message-ID: <20090406101610.6f3e14d4@lxorguk.ukuu.org.uk>
In-Reply-To: <20090406054014.GB12019@kroah.com>
References: <200903261929.n2QJTUX1009811@hera.kernel.org>
	<20090326194421.41816289@lxorguk.ukuu.org.uk>
	<20090406054014.GB12019@kroah.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm trying to get this driver working properly for a USB device that is
> being controlled by a Windows program running under WINE.  Right now
> there are some ioctls being called by either WINE or the serial program
> on Windows that the driver isn't handling and so it's not working
> properly.  This change was so that I could get feedback from the user
> with this situation to try to work it all out.

In future perhaps you could keep your private debugging patches in your
own tree as it would make it easier for anyone else. What you actually
submitted was code which in the presence of the hardware gets autoloaded
and allows people to spam the log files depending upon the distro serial
permissions policy for USB dongles.

> I've now got a trace of an attempt and will work to try to implement the
> needed ioctls to get it running properly.

Out of interest what does WINE think it needs ?

Alan
