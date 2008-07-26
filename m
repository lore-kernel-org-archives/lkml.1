Return-Path: <linux-kernel-owner+w=401wt.eu-S1755595AbYGZPih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbYGZPih (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 11:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752409AbYGZPia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 11:38:30 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36193 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbYGZPi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 11:38:29 -0400
Date: Sat, 26 Jul 2008 16:32:10 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       tim@physik3.uni-rostock.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nwflash: fix build errors and warning
Message-ID: <20080726153210.GD8871@flint.arm.linux.org.uk>
References: <200807250848.m6P8mIWF001718@imap1.linux-foundation.org> <20080726141808.GB8871@flint.arm.linux.org.uk> <20080726150155.GA3562@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080726150155.GA3562@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2008 at 12:02:20AM +0900, Akinobu Mita wrote:
> On Sat, Jul 26, 2008 at 03:18:08PM +0100, Russell King - ARM Linux wrote:
> > On Fri, Jul 25, 2008 at 01:48:18AM -0700, akpm@linux-foundation.org wrote:
> > > From: Akinobu Mita <akinobu.mita@gmail.com>
> > > 
> > > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > > Cc: Russell King <linux@arm.linux.org.uk>
> > > Cc: Tim Schmielau <tim@physik3.uni-rostock.de>
> > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > 
> > Argh...  Are people now submitting untested patches as a rule?
> > 
> > drivers/char/nwflash.c: In function 'flash_read':
> > drivers/char/nwflash.c:129: error: 'p' undeclared (first use in this function)
> > drivers/char/nwflash.c:129: error: (Each undeclared identifier is reported only once
> > drivers/char/nwflash.c:129: error: for each function it appears in.)
> > drivers/char/nwflash.c:129: error: 'count' undeclared (first use in this function)
> > drivers/char/nwflash.c:136: warning: passing argument 4 of 'simple_read_from_buffer' discards qualifiers from pointer target type
> > make[2]: *** [drivers/char/nwflash.o] Error 1
> > make[1]: *** [drivers/char] Error 2
> > make: *** [drivers] Error 2
> 
> Sorry. I'm preparing cross compiler. But this patch should fix this
> problem.

I sort of did the same - but merely changing the names of the variables
generates other warnings.  More complete (and build-tested) commit
queued up:

http://ftp.arm.linux.org.uk/git/gitweb.cgi?p=linux-2.6-arm.git;a=commitdiff;h=4ef584ba84125b67c17b5aded38e7783cd8cdef0
