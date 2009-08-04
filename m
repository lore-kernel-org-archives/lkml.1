Return-Path: <linux-kernel-owner+w=401wt.eu-S932947AbZHDQDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932947AbZHDQDU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 12:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932635AbZHDQDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 12:03:19 -0400
Received: from kroah.org ([198.145.64.141]:52777 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932297AbZHDQDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 12:03:19 -0400
Date: Tue, 4 Aug 2009 09:00:44 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@mail.by>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: proper tty-ldisc refcounting (was Re: WARNING at:
 drivers/char/tty_ldisc.c)
Message-ID: <20090804160044.GA21153@kroah.com>
References: <alpine.LFD.2.01.0908021654010.3352@localhost.localdomain>
 <alpine.LFD.2.01.0908031047010.3208@localhost.localdomain>
 <20090803181811.GA15848@kroah.com>
 <20090804003009.GA3121@localdomain.by>
 <alpine.LFD.2.01.0908031751270.3270@localhost.localdomain>
 <20090804035319.GA7248@kroah.com>
 <20090804040834.GA16696@kroah.com>
 <alpine.LFD.2.01.0908032319290.3270@localhost.localdomain>
 <20090804072351.GA17474@kroah.com>
 <alpine.LFD.2.01.0908040825210.3270@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0908040825210.3270@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 04, 2009 at 08:40:20AM -0700, Linus Torvalds wrote:
> I suspect we should take the three now. All of the issues are due to 
> totally rewritten code since 2.6.30 - I suspect the risk from new bugs 
> from that refcounting series is _smaller_ that the risk of bugs from the 
> original ldisc rewrite (commit c65c9bc3e), and if there are bugs, I 
> suspect the three patches are more likely to help than to hurt.

Ok, let me make up a git queue for you to pull them from and test it
first.  It will take a few hours, I have to play taxi for the kids
different summer camps this morning.

thanks,

greg k-h
