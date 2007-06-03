Return-Path: <linux-kernel-owner+w=401wt.eu-S1751617AbXFCUcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617AbXFCUcs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 16:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751082AbXFCUcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 16:32:42 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:58329 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbXFCUcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 16:32:41 -0400
X-Originating-Ip: 72.143.65.211
Date: Sun, 3 Jun 2007 16:31:08 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Kconfig variable "COBALT" is not defined anywhere
In-Reply-To: <20070603132309.508738b7.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0706031630030.26035@localhost.localdomain>
References: <Pine.LNX.4.64.0706031315230.23477@localhost.localdomain>
 <20070603132309.508738b7.randy.dunlap@oracle.com>
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

On Sun, 3 Jun 2007, Randy Dunlap wrote:

> On Sun, 3 Jun 2007 13:17:48 -0400 (EDT) Robert P. J. Day wrote:
>
> >
> >   (no one's listed as the official cobalt maintainer so i thought i'd
> > just throw this out there.)
> >
> >   there is no Kconfig file which defines the selectable option
> > "COBALT", which means that this snippet from drivers/char/nvram.c:
> >
> > #  if defined(CONFIG_COBALT)
> > #    include <linux/cobalt-nvram.h>
> > #    define MACH COBALT
> > #  else
> > #    define MACH PC
> > #  endif
> >
> > never evaluates to true, therefore making <linux/cobalt-nvram.h>
> > fairly useless, at least under the circumstances.
>
> Maybe it should be MIPS_COBALT ?

that's the first thing that occurred to me, but that header file is
copyright sun microsystems and says nothing about MIPS, so that didn't
really settle the issue.  that's why i'd rather someone else resolve
this one way or the other.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
