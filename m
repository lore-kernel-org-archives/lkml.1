Return-Path: <linux-kernel-owner+w=401wt.eu-S1755670AbXJJRa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670AbXJJRa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 13:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754231AbXJJRaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 13:30:20 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:55706 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175AbXJJRaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 13:30:20 -0400
X-Originating-Ip: 99.236.101.138
Date: Wed, 10 Oct 2007 13:26:16 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: cleaning up "make headers_install" for various architectures
In-Reply-To: <20071010095954.79c39a73.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0710101324230.6071@localhost.localdomain>
References: <Pine.LNX.4.64.0710101234340.32502@localhost.localdomain>
 <20071010095954.79c39a73.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2007, Randy Dunlap wrote:

> On Wed, 10 Oct 2007 12:44:58 -0400 (EDT) Robert P. J. Day wrote:
>
> >   the final example, parisc, just plain fails:
> >
> > $ make ARCH=parisc headers_install
> > /home/rpjday/k/git/scripts/gcc-version.sh: line 16: hppa-linux-gcc: command not found
> > /home/rpjday/k/git/scripts/gcc-version.sh: line 17: hppa-linux-gcc: command not found
> > /home/rpjday/k/git/arch/parisc/Makefile:39: *** Sorry, GCC v3.3 or above is required..  Stop.
>
>
> Try
> $ make CROSS_COMPILE="" CC=gcc ARCH=parisc headers_install
>
> :(
> ---
> ~Randy

oh, i know how to get around it -- i was just thinking that it
shouldn't *require* a workaround, that's all.  all of those previous
warnings and errors are clearly due to the early part of the make
testing for the appropriate arch-specific build tools without
realizing that the make target doesn't *need* any of those things just
to install headers.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
