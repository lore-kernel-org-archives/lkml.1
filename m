Return-Path: <linux-kernel-owner+w=401wt.eu-S1755468AbZHTVUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468AbZHTVUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 17:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755457AbZHTVUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 17:20:34 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:60104 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755438AbZHTVUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 17:20:33 -0400
Date: Thu, 20 Aug 2009 17:20:35 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: Oops when USB Serial disconnected while
 in use
In-Reply-To: <20090820212549.7b4d93c9@neptune.home>
Message-ID: <Pine.LNX.4.44L0.0908201716190.2422-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Aug 2009, Bruno [UTF-8] Prémont wrote:

> No, that one does not really help (well it avoids dereferencing a bad
> pointer (NULL for pl2302 or invalid for ftdi) with serial_do_free() after
> destroy_serial() but is does underflow module refcount (refcount ends
> up at 2^32-1) and lets the kernel stall/panic a short time later without
> any useful information at that moment (only very first line of trace
> ever appears) [ftdi for the panic/freeze].

More information, please.  Does the problem occur with the pl2303 or 
only with the ftdi?  Which module's refcount underflows?  What else can 
you provide?

I don't see the same sort of thing with my pl2303 device, but maybe
I'm using a different version of minicom.

Alan Stern

