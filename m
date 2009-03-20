Return-Path: <linux-kernel-owner+w=401wt.eu-S1756996AbZCTPgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996AbZCTPgj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 11:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbZCTPga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 11:36:30 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51336 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751315AbZCTPg3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 11:36:29 -0400
Date: Fri, 20 Mar 2009 15:37:13 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel =?ISO-8859-14?B?S3L8Z2Vy?= 
	<daniel.krueger@systec-electronic.com>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Michael Olbrich <mol@pengutronix.de>,
       Wolfram Sang <wsa@pengutronix.de>,
       Marc Kleine-Budde <mkl@pengutronix.de>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: The Linux Staging tree, what it is and is not.
Message-ID: <20090320153713.65bf8e2d@lxorguk.ukuu.org.uk>
In-Reply-To: <49C3B33F.1020905@systec-electronic.com>
References: <20090318183232.GA11594@kroah.com>
	<20090320005808.GM5367@pengutronix.de>
	<20090320100146.6599f671@lxorguk.ukuu.org.uk>
	<20090320103545.GQ5367@pengutronix.de>
	<20090320105556.4375176d@lxorguk.ukuu.org.uk>
	<20090320111552.GS5367@pengutronix.de>
	<49C3B33F.1020905@systec-electronic.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> My understanding of an object dictionary is that it is only a structured 
> view to a set of configuration variables, process variables and 
> diagnostic information. It could also be an XML file or a simple C 
> struct. In our implementation the object dictionary is not necessarily 
> the backing store of the data. The process variables for example are 

It's also possible I think to look at the object dictionary as no
different from port numbers. The object identifiers tell you who owns the
data and thus who needs to be told. I admit to being a bit rusty on this.
My last near encounters with fieldbus type systems were some years ago
when I²IT was involved in EMUG and OLCHFA and I managed to keep out of
the blast radius of those ;)

> information of what to copy to where comes from the object dictionary. 
> But it is possible to extract this information from the objdict and pass 
> it via generic structures (e.g. something like IO vectors) to the PDO 
> module in kernel. The information flow of the configuration data is 
> one-way only, from userspace to kernel. This is what I plan to implement 
> in openPOWERLINK, because the copy information can also be passed to a 
> special hardware like a DMA controller.

Ok so your hardware in fact really is oriented around an mmap type
interface ?

Alan
