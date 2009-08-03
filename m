Return-Path: <linux-kernel-owner+w=401wt.eu-S1754204AbZHCBpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbZHCBpS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 21:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbZHCBpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 21:45:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754141AbZHCBpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 21:45:16 -0400
Date: Sun, 2 Aug 2009 18:44:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Sergey Senozhatsky <sergey.senozhatsky@mail.by>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: Re: WARNING at: drivers/char/tty_ldisc.c
In-Reply-To: <alpine.LFD.2.01.0908021654010.3352@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0908021840480.3352@localhost.localdomain>
References: <20090802120120.GA3097@localdomain.by> <alpine.LFD.2.01.0908020940530.3352@localhost.localdomain> <20090802190514.GA3278@localdomain.by> <alpine.LFD.2.01.0908021254580.3352@localhost.localdomain> <87k51l9apo.fsf@devron.myhome.or.jp>
 <alpine.LFD.2.01.0908021423490.3352@localhost.localdomain> <20090802234851.3fd1ac2c@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0908021654010.3352@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 2 Aug 2009, Linus Torvalds wrote:
> 
> I'll try with a serial console on one of my machines to see if I can see 
> anything wrong. It _would_ be nice to get rid of that thing, since it 
> clearly causes problems.

Hmm. I don't see anything wrong. Either as a pure serial console with no 
login (console=ttyS0,115400 console=tty0) or with the serial console 
actually being /dev/console and having a login on it etc.

But I have to admit to only using serial consoles for some very 
occasional debugging, so I might have missed any behavioral differences. 
It rebooted cleanly with no messages. But in this case "no messages" can 
obviously be both a good and a bad thing ;)

		Linus
