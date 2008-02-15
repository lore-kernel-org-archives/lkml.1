Return-Path: <linux-kernel-owner+w=401wt.eu-S1761488AbYBOTIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761488AbYBOTIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 14:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755770AbYBOTII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 14:08:08 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35443 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755819AbYBOTIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 14:08:06 -0500
Date: Fri, 15 Feb 2008 19:00:11 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Dan Gora" <dan.gora@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PCI Bursting with PIO
Message-ID: <20080215190011.56e4080c@core>
In-Reply-To: <4779de450802151000o2c06df0fq6d0daa22c43b935b@mail.gmail.com>
References: <4779de450802141928led16cebkfb989551eb88a8cb@mail.gmail.com>
	<20080215130244.780285cf@core>
	<4779de450802151000o2c06df0fq6d0daa22c43b935b@mail.gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2008 10:00:28 -0800
"Dan Gora" <dan.gora@gmail.com> wrote:

> On Fri, Feb 15, 2008 at 5:02 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > > Is there any way to get PIO to burst over the PCI bus in the read and
> >  > write direction?  My device has 4 BAR registers, but the area where I
> >
> >  I think you are doign about as well as the X folks did when they spent
> >  time on trying to optimise pio transfers to and from graphics card RAM.
> >
> 
> That's good to know.  Do you have a link or anything to their
> discussion or some key words that I could hunt it down?

It was some time ago but a look at the X tree will find you the code.
It's basically the same as you did - using MMX.
