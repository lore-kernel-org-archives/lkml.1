Return-Path: <linux-kernel-owner+w=401wt.eu-S1767224AbXCIMwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767224AbXCIMwc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 07:52:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767233AbXCIMwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 07:52:32 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:47085 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767224AbXCIMwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 07:52:31 -0500
X-Originating-Ip: 74.109.98.130
Date: Fri, 9 Mar 2007 07:48:47 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: any thoughts yet on a "generic" ioctl.h?
In-Reply-To: <45F15547.6040207@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.64.0703090737230.1617@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0703081556260.9349@CPE00045a9c397f-CM001225dbafb6>
 <45F0D798.4050602@s5r6.in-berlin.de> <Pine.LNX.4.64.0703090450160.30726@CPE00045a9c397f-CM001225dbafb6>
 <45F14232.5060703@s5r6.in-berlin.de> <Pine.LNX.4.64.0703090617050.880@CPE00045a9c397f-CM001225dbafb6>
 <45F15547.6040207@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2007, Stefan Richter wrote:

> Robert P. J. Day wrote:
> > if someone can't immediately see what i'm trying
> > to do given the previously-posted patch, then they shouldn't be
> > commenting on it one way or the other.
>
> I'm not sure if you are addressing me too.  Just to clarify:  I
> wasn't commenting on the patch, I only commented on what I quoted in
> my reply.

sorry, i worded that *really* badly.  i didn't mean to imply that
*you* were incapable of understanding what the patch represented --
i've seen enough of your posts to appreciate your technical expertise.

all i want to know is if the proposed patch making
include/asm-generic/ioctl.h more flexible is even *theoretically* a
feasible thing to do, or whether anyone on this list would have any
howling objections to it.

not only that, but i would *prefer* to submit just that file as a
first patch all by itself since, again theoretically, it shouldn't
break anything and i'd like to verify that first before trying to
simplify any of the arch-specific ioctl.h files one at a time.

as it is, the number of arch-specific ioctl.h files that could
potentially be made *much* shorter are for the arches:

  mips
  parisc
  alpha
  sparc
  sparc-64
  powerpc

all the rest simply include asm-generic/ioctl.h directly.

rday

p.s.  for those who may have come in late, the proposed new
asm-generic/ioctl.h file would allow an includer to override any or
all of:

  _IOC_SIZEBITS
  _IOC_DIRBITS
  _IOC_NONE
  _IOC_WRITE
  _IOC_READ

AFAICT, those are the only differences across the entire spectrum of
ioctl.h files.  if there's something i've missed, feel free to let me
know.

--
========================================================================
Robert P. J. Day Linux Consulting, Training and Annoying Kernel
Pedantry Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
