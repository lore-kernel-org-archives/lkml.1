Return-Path: <linux-kernel-owner+w=401wt.eu-S938837AbXFHMmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938837AbXFHMmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 08:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937232AbXFHMmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 08:42:15 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:32884 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937143AbXFHMmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 08:42:14 -0400
X-Originating-Ip: 72.143.66.27
Date: Fri, 8 Jun 2007 08:40:22 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Kyle McMartin <kyle@canonical.com>
cc: Christoph Pleger <Christoph.Pleger@cs.uni-dortmund.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Size of kernel modules
In-Reply-To: <20070608034421.GM26717@fattire.cabal.ca>
Message-ID: <Pine.LNX.4.64.0706080838210.17480@localhost.localdomain>
References: <20070606170534.67b5dea9.Christoph.Pleger@cs.uni-dortmund.de>
 <20070608034421.GM26717@fattire.cabal.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007, Kyle McMartin wrote:

> On Wed, Jun 06, 2007 at 05:05:34PM +0200, Christoph Pleger wrote:
> > So, my question is the follwing: Is it an expected feature that the file
> > sizes of modules grow so much only because of a different cpu type and a
> > different localversion, or is there probably a bug in my build tools?
>
> The kernel is compiled with debug info so that we can strip it later to
> build two packages, one with debugging information intact, and one
> without it.
>
> If you disable CONFIG_DEBUG_KERNEL, things should go back to normal
> sizes for you.

grow so much compared to *which other modules*?  the ones that came
with your distro?  if that's the case, try installing your new modules
with

  # make INSTALL_MOD_STRIP=1 modules_install

that makes a *huge* difference in the size of the installed modules,
as i learned when i first ran across this on my fedora core system.

rday
--
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
