Return-Path: <linux-kernel-owner+w=401wt.eu-S1754671AbZITQhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbZITQhh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 12:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754509AbZITQhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 12:37:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:52553 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbZITQhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 12:37:36 -0400
Date: Sun, 20 Sep 2009 18:37:44 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Status of Bug 8094 -  ipaq oops on connecting "Vodafone VPA-II"
 ?
Message-ID: <20090920183744.395fc407@infradead.org>
In-Reply-To: <4AB6581F.5040908@imap.cc>
References: <4AB630AD.90207@imap.cc>
	<20090920150549.GC11621@kroah.com>
	<4AB6581F.5040908@imap.cc>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Sep 2009 18:28:15 +0200
Tilman Schmidt <tilman@imap.cc> wrote:

> Greg KH schrieb:
> > Can you provide a log message that shows the problem you are having
> > with the 2.6.31 kernel?
> 
> Attached. Currently only from an Nvidia-tainted kernel, though.
> If you need it reproduced on an untainted kernel it'll have to
> wait until I can reboot the machine.
> 
> The Oops location according to gdb is:
> 
> (gdb) info line *ipaq_open+0x1cf
> Line 656 of "drivers/usb/serial/ipaq.c" starts at address 0x986
> <ipaq_open+457> and ends at 0x98f <ipaq_open+466>.
> 

btw this is what scripts/markup_oops.pl is for... it gives a very nice
diagnostic
