Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbXIMHWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbXIMHWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 03:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751074AbXIMHWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 03:22:45 -0400
Received: from ozlabs.org ([203.10.76.45]:41700 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbXIMHWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 03:22:44 -0400
From: Michael Neuling <mikey@neuling.org>
To: Jan Dittmer <jdi@l4x.org>
cc: Paul Mackerras <paulus@samba.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, Tony Breeds <tony@bakeyournoodle.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Alan Cox <alan@redhat.com>, davem@davemloft.net,
       heiko.carstens@de.ibm.com, hskinnemoen@atmel.com, dhowells@redhat.com
Subject: Re: Define termios_1 functions for powerpc, s390, avr32 and frv 
In-reply-to: <46E8DF49.7090402@l4x.org> 
References: <18152.719.316280.579601@cargo.ozlabs.ibm.com> <46E8DF49.7090402@l4x.org>
Comments: In-reply-to Jan Dittmer <jdi@l4x.org>
   message dated "Thu, 13 Sep 2007 08:57:13 +0200."
X-Mailer: MH-E 8.0.3; nmh 1.2; GNU Emacs 21.4.1
Date: Thu, 13 Sep 2007 17:22:36 +1000
Message-ID: <5058.1189668156@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Commit f629307c857c030d5a3dd777fee37c8bb395e171 introduced uses of
> > kernel_termios_to_user_termios_1 and user_termios_to_kernel_termios_1
> > on all architectures.  However, powerpc, s390, avr32 and frv don't
> > currently define those functions since their termios struct didn't
> > need to be changed when the arbitrary baud rate stuff was added, and
> > thus the kernel won't currently build on those architectures.
> 
> alpha, parisc, sh, sparc{64,}, xtensa are still broken with this error...

They need to include <asm-generic/termios.h> in asm-<arch>/termios.h
like in powerpc.

Alternatively tonyb's patch should fix them.  Could also do that?

Mikey
