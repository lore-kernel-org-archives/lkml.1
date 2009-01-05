Return-Path: <linux-kernel-owner+w=401wt.eu-S1754506AbZAELNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbZAELNu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 06:13:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbZAELNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 06:13:41 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53902 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752843AbZAELNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 06:13:40 -0500
Date: Mon, 5 Jan 2009 11:13:21 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Heikki Orsila <shdl@zakalwe.fi>
Cc: unsik Kim <donari75@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] mflash linux support
Message-ID: <20090105111321.7d210c01@lxorguk.ukuu.org.uk>
In-Reply-To: <20090105023346.GE6115@zakalwe.fi>
References: <57afda040901041718g1415e210hfd0991270dfdd72d@mail.gmail.com>
	<20090105023346.GE6115@zakalwe.fi>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2009 04:33:46 +0200
Heikki Orsila <shdl@zakalwe.fi> wrote:

> A few style issues:

How about starting by worrying about the code not pointless style
complaints ?

>> > +	switch (cmd) {
> > +	case HDIO_GETGEO:
> 
> 	if (cmd == HDIO_GETGEO) {

Especially when you are making pointless complaints about things that are
generally done the way the original code is - and for good reason. It
makes it far cleaner to add new ioctl support.


It would be interesting to see what mflash looked like as a libata driver
but I think for embedded systems the driver as submitted shows great
promise.
