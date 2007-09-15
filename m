Return-Path: <linux-kernel-owner+w=401wt.eu-S1755429AbXIOMzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbXIOMzU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 08:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752261AbXIOMyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 08:54:50 -0400
Received: from honk1.physik.uni-konstanz.de ([134.34.140.224]:36796 "EHLO
	honk1.physik.uni-konstanz.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752133AbXIOMys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 08:54:48 -0400
Date: Sat, 15 Sep 2007 14:54:11 +0200
From: Guido Guenther <agx@sigxcpu.org>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Andy Whitcroft <apw@shadowen.org>, Alan Cox <alan@redhat.com>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: 2.6.23-rc6-git1 -- termios *_1 compile failures on powerpc
Message-ID: <20070915125411.GA6013@bogon.ms20.nix>
References: <20070912115823.GG4835@shadowen.org> <625fc13d0709120733w32878f94oca2034f12f47c30c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <625fc13d0709120733w32878f94oca2034f12f47c30c@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2007 at 09:33:12AM -0500, Josh Boyer wrote:
> On 9/12/07, Andy Whitcroft <apw@shadowen.org> wrote:
> > The following commit just hit mainline and all my powerpc test boxes are
> > failing during compilation:
> >
> >         commit f629307c857c030d5a3dd777fee37c8bb395e171
> >         tty: termios locking functions break with new termios type
> 
> I think this is already being discussed on the linuxppc-dev list.
The same thing hits sparc64:

  CC      drivers/char/tty_ioctl.o
drivers/char/tty_ioctl.c: In function 'n_tty_ioctl':
drivers/char/tty_ioctl.c:799: error: implicit declaration of function 'kernel_termios_to_user_termios_1'
drivers/char/tty_ioctl.c:806: error: implicit declaration of function 'user_termios_to_kernel_termios_1'
make[2]: *** [drivers/char/tty_ioctl.o] Error 1
make[1]: *** [drivers/char] Error 2
make: *** [drivers] Error 2

Cheers,
 -- Guido

