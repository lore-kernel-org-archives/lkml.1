Return-Path: <linux-kernel-owner+w=401wt.eu-S1752960AbZHBQGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbZHBQGb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 12:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbZHBQGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 12:06:30 -0400
Received: from kroah.org ([198.145.64.141]:39748 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834AbZHBQGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 12:06:30 -0400
Date: Sun, 2 Aug 2009 09:05:32 -0700
From: Greg KH <greg@kroah.com>
To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: WARNING at: drivers/char/tty_ldisc.c
Message-ID: <20090802160532.GA25312@kroah.com>
References: <20090802120120.GA3097@localdomain.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090802120120.GA3097@localdomain.by>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 02, 2009 at 03:01:20PM +0300, Sergey Senozhatsky wrote:
> Hello Linus, Ogawa,
> Looks like we have one more bug in tty code:
> 'shutdown -r now' in 'single' user mode gives following trace:
> 
> WARNING at: drivers/char/tty_ldisc.c:209 tty_ldisc_put+0x95/0xa0

Ugh, someone still has a ldisc reference somehow.  Does this happen for
you on a "normal" boot and shutdown?

thanks,

greg k-h
