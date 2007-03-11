Return-Path: <linux-kernel-owner+w=401wt.eu-S932404AbXCKVO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404AbXCKVO1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 17:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932488AbXCKVO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 17:14:27 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:43690 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932404AbXCKVO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 17:14:26 -0400
X-Originating-Ip: 74.109.98.130
Date: Sun, 11 Mar 2007 17:11:42 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Eric Moore <eric.moore@lsi.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] MPT FUSION:  Delete unused header files.
In-Reply-To: <20070311195553.GA12056@lsil.com>
Message-ID: <Pine.LNX.4.64.0703111708210.3599@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0703101656150.28403@CPE00045a9c397f-CM001225dbafb6>
 <20070311195553.GA12056@lsil.com>
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

On Sun, 11 Mar 2007, Eric Moore wrote:

> On Sat, Mar 10, 2007 at 04:57:35PM -0500, Robert P. J. Day wrote:
> >
> >   Delete apparently unused header files.
> >
> > Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> >
> > ---
> >
> >  drivers/message/fusion/lsi/mpi_inb.h    |  221 ----------------------
> >  drivers/message/fusion/lsi/mpi_log_fc.h |   89 --------
> >  2 files changed, 310 deletions(-)
> >
>
> NACK.
>
> Thanks, but no thanks.  Don't remove these header files.  These are
> the mpi header files that define the interface between firmware and
> drivers.  This set of headers are bundled with each flavor OS, and
> we are constantly providing update files when changes occur.

either way works for me, i was just identifying unused header files.

rday

p.s.  just to clarify, when i use the adjective "unused", i mean that
that header file is not used *anywhere* in the source tree -- not even
in an include that is currently commented out or conditionally
included.  i mean *nowhere* (as long as i didn't screw up my
programming, that is).

so whether people want to keep those header files in the tree is up to
them.

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
