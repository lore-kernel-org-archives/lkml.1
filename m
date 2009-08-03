Return-Path: <linux-kernel-owner+w=401wt.eu-S932296AbZHCW0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296AbZHCW0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 18:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbZHCW0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 18:26:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51947 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752302AbZHCW0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 18:26:45 -0400
Date: Mon, 3 Aug 2009 15:25:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
cc: Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] proper tty-ldisc refcounting (was Re: WARNING at:
 drivers/char/tty_ldisc.c)
In-Reply-To: <20090803221651.GA3122@localdomain.by>
Message-ID: <alpine.LFD.2.01.0908031521300.3208@localhost.localdomain>
References: <20090802120120.GA3097@localdomain.by> <alpine.LFD.2.01.0908020940530.3352@localhost.localdomain> <20090802190514.GA3278@localdomain.by> <alpine.LFD.2.01.0908021254580.3352@localhost.localdomain> <87k51l9apo.fsf@devron.myhome.or.jp>
 <alpine.LFD.2.01.0908021423490.3352@localhost.localdomain> <20090802234851.3fd1ac2c@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0908021654010.3352@localhost.localdomain> <alpine.LFD.2.01.0908031047010.3208@localhost.localdomain> <20090803181811.GA15848@kroah.com>
 <20090803221651.GA3122@localdomain.by>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 4 Aug 2009, Sergey Senozhatsky wrote:

> On (08/03/09 11:18), Greg KH wrote:
> > Ok, I'll queue them up if they pass Sergey's testing.
> > 
> 
> I've been away. Sorry.
> Will test ASAP.

Absolutely nothing to be sorry about - you've been an exemplary tester 
with very low latency. Thanks a lot.

Ogawa found a race in my original 2/2, and Greg has a small fix pending, 
but that almost certainly won't realistically matter for any real-life 
testing, so you don't really need to worry about it. 

But I'll forward that patch (and another couple cleanup patch) for you for 
testing after I've verified it myself. But don't feel like you have to 
worry about those extra patches - testing the initial refcount handling is 
the thing that matters most, the thing I have pending really is just 
details.

		Linus
