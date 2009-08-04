Return-Path: <linux-kernel-owner+w=401wt.eu-S932528AbZHDHYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528AbZHDHYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 03:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932515AbZHDHYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 03:24:51 -0400
Received: from kroah.org ([198.145.64.141]:47329 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932514AbZHDHYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:24:51 -0400
Date: Tue, 4 Aug 2009 00:23:51 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@mail.by>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: proper tty-ldisc refcounting (was Re: WARNING at:
 drivers/char/tty_ldisc.c)
Message-ID: <20090804072351.GA17474@kroah.com>
References: <alpine.LFD.2.01.0908021423490.3352@localhost.localdomain>
 <20090802234851.3fd1ac2c@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.01.0908021654010.3352@localhost.localdomain>
 <alpine.LFD.2.01.0908031047010.3208@localhost.localdomain>
 <20090803181811.GA15848@kroah.com>
 <20090804003009.GA3121@localdomain.by>
 <alpine.LFD.2.01.0908031751270.3270@localhost.localdomain>
 <20090804035319.GA7248@kroah.com>
 <20090804040834.GA16696@kroah.com>
 <alpine.LFD.2.01.0908032319290.3270@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0908032319290.3270@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 11:19:53PM -0700, Linus Torvalds wrote:
> 
> 
> On Mon, 3 Aug 2009, Greg KH wrote:
> > 
> > Oh wait, the original problem, single user mode.  Hm, we need all of
> > these to fix that problem?  Or just the first one?
> 
> Patches 1-3 should fix that one. 4-5 are just cleanups with no semantic 
> changes.

Ok, but due to the lateness of the release cycle, is it worth it to add
those 3 right now?  Or do we just take the BUG_ON() out as it's pretty
harmless while shutting down in single user mode?

What do you think?

greg k-h
