Return-Path: <linux-kernel-owner+w=401wt.eu-S1755320AbZHUJeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbZHUJeR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 05:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755284AbZHUJeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 05:34:16 -0400
Received: from ppp-153-131.adsl.restena.lu ([158.64.153.131]:45155 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282AbZHUJeP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 05:34:15 -0400
X-Greylist: delayed 470 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Aug 2009 05:34:15 EDT
Date: Fri, 21 Aug 2009 11:25:54 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: Oops when USB Serial disconnected while
 in use
Message-ID: <20090821112554.18a297fa@pluto.restena.lu>
In-Reply-To: <Pine.LNX.4.44L0.0908201716190.2422-100000@iolanthe.rowland.org>
References: <20090820212549.7b4d93c9@neptune.home>
	<Pine.LNX.4.44L0.0908201716190.2422-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Aug 2009 17:20:35 Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 20 Aug 2009, Bruno [UTF-8] Prémont wrote:
> 
> > No, that one does not really help (well it avoids dereferencing a
> > bad pointer (NULL for pl2302 or invalid for ftdi) with
> > serial_do_free() after destroy_serial() but is does underflow
> > module refcount (refcount ends up at 2^32-1) and lets the kernel
> > stall/panic a short time later without any useful information at
> > that moment (only very first line of trace ever appears) [ftdi for
> > the panic/freeze].
> 
> More information, please.  Does the problem occur with the pl2303 or 
> only with the ftdi?  Which module's refcount underflows?  What else
> can you provide?

The module refcount was for both. It's the pl2302/ftdi-sio module's
refcount.

I don't remember for sure about the panic if it also affects
pl2302 or not.
At least one of the panics was when running dmesg after exiting minicom.

I will redo the tests this evening when I get home and report back with
more details.

> I don't see the same sort of thing with my pl2303 device, but maybe
> I'm using a different version of minicom.
> 
> Alan Stern

Bruno
