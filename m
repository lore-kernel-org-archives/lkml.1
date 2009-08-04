Return-Path: <linux-kernel-owner+w=401wt.eu-S932453AbZHDGUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453AbZHDGUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 02:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932436AbZHDGUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 02:20:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47157 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932429AbZHDGUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 02:20:19 -0400
Date: Mon, 3 Aug 2009 23:19:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Greg KH <greg@kroah.com>
cc: Sergey Senozhatsky <sergey.senozhatsky@mail.by>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: proper tty-ldisc refcounting (was Re: WARNING at:
 drivers/char/tty_ldisc.c)
In-Reply-To: <20090804040834.GA16696@kroah.com>
Message-ID: <alpine.LFD.2.01.0908032319290.3270@localhost.localdomain>
References: <alpine.LFD.2.01.0908021254580.3352@localhost.localdomain> <87k51l9apo.fsf@devron.myhome.or.jp> <alpine.LFD.2.01.0908021423490.3352@localhost.localdomain> <20090802234851.3fd1ac2c@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0908021654010.3352@localhost.localdomain>
 <alpine.LFD.2.01.0908031047010.3208@localhost.localdomain> <20090803181811.GA15848@kroah.com> <20090804003009.GA3121@localdomain.by> <alpine.LFD.2.01.0908031751270.3270@localhost.localdomain> <20090804035319.GA7248@kroah.com>
 <20090804040834.GA16696@kroah.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 3 Aug 2009, Greg KH wrote:
> 
> Oh wait, the original problem, single user mode.  Hm, we need all of
> these to fix that problem?  Or just the first one?

Patches 1-3 should fix that one. 4-5 are just cleanups with no semantic 
changes.

		Linus
