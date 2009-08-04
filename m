Return-Path: <linux-kernel-owner+w=401wt.eu-S1750885AbZHDEDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750885AbZHDEDU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 00:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750734AbZHDEDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 00:03:19 -0400
Received: from kroah.org ([198.145.64.141]:60624 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbZHDEDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 00:03:18 -0400
Date: Mon, 3 Aug 2009 20:53:19 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@mail.by>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: proper tty-ldisc refcounting (was Re: WARNING at:
 drivers/char/tty_ldisc.c)
Message-ID: <20090804035319.GA7248@kroah.com>
References: <20090802190514.GA3278@localdomain.by>
 <alpine.LFD.2.01.0908021254580.3352@localhost.localdomain>
 <87k51l9apo.fsf@devron.myhome.or.jp>
 <alpine.LFD.2.01.0908021423490.3352@localhost.localdomain>
 <20090802234851.3fd1ac2c@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.01.0908021654010.3352@localhost.localdomain>
 <alpine.LFD.2.01.0908031047010.3208@localhost.localdomain>
 <20090803181811.GA15848@kroah.com>
 <20090804003009.GA3121@localdomain.by>
 <alpine.LFD.2.01.0908031751270.3270@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0908031751270.3270@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 05:56:07PM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 4 Aug 2009, Sergey Senozhatsky wrote:
> >   
> > Works for me (SMP/non-SMP x86 builds). Great job.
> >   
> > Tested-by: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
> 
> Thanks.
> 
> Greg - feel free to treat 4/2 and 5/2 any way you want. They are obvious 
> enough (no subtle issues) that I'll happily pull them into 2.6.31 too: 
> relative to the initial refcount changes (which it looks like we'll need 
> to do just to fix the regression) they are pretty safe.
> 
> But at the same time, they can equally well go into some later tree for 
> the next merge window. So whatever you want to do.

I'll queue them up for .32 as they don't fix a bug that people are
hitting from what I can tell.

thanks,

greg k-h
