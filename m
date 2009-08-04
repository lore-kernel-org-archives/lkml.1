Return-Path: <linux-kernel-owner+w=401wt.eu-S1752612AbZHDA43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbZHDA43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 20:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbZHDA42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 20:56:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47337 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751323AbZHDA42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 20:56:28 -0400
Date: Mon, 3 Aug 2009 17:56:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
cc: Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: proper tty-ldisc refcounting (was Re: WARNING at:
 drivers/char/tty_ldisc.c)
In-Reply-To: <20090804003009.GA3121@localdomain.by>
Message-ID: <alpine.LFD.2.01.0908031751270.3270@localhost.localdomain>
References: <20090802120120.GA3097@localdomain.by> <alpine.LFD.2.01.0908020940530.3352@localhost.localdomain> <20090802190514.GA3278@localdomain.by> <alpine.LFD.2.01.0908021254580.3352@localhost.localdomain> <87k51l9apo.fsf@devron.myhome.or.jp>
 <alpine.LFD.2.01.0908021423490.3352@localhost.localdomain> <20090802234851.3fd1ac2c@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0908021654010.3352@localhost.localdomain> <alpine.LFD.2.01.0908031047010.3208@localhost.localdomain> <20090803181811.GA15848@kroah.com>
 <20090804003009.GA3121@localdomain.by>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 4 Aug 2009, Sergey Senozhatsky wrote:
>   
> Works for me (SMP/non-SMP x86 builds). Great job.
>   
> Tested-by: Sergey Senozhatsky <sergey.senozhatsky@mail.by>

Thanks.

Greg - feel free to treat 4/2 and 5/2 any way you want. They are obvious 
enough (no subtle issues) that I'll happily pull them into 2.6.31 too: 
relative to the initial refcount changes (which it looks like we'll need 
to do just to fix the regression) they are pretty safe.

But at the same time, they can equally well go into some later tree for 
the next merge window. So whatever you want to do.

			Linus
