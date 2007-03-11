Return-Path: <linux-kernel-owner+w=401wt.eu-S1750894AbXCKUvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750894AbXCKUvh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 16:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750992AbXCKUvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 16:51:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56917
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750894AbXCKUvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 16:51:36 -0400
Date: Sun, 11 Mar 2007 13:51:34 -0700 (PDT)
Message-Id: <20070311.135134.125894940.davem@davemloft.net>
To: eric.moore@lsi.com
Cc: rpjday@mindspring.com, linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH] MPT FUSION: Delete unused header files.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070311195553.GA12056@lsil.com>
References: <Pine.LNX.4.64.0703101656150.28403@CPE00045a9c397f-CM001225dbafb6>
	<20070311195553.GA12056@lsil.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Moore <eric.moore@lsi.com>
Date: Sun, 11 Mar 2007 13:55:54 -0600

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
> Thanks, but no thanks.  Don't remove these header files.  These are the mpi
> header files that define the interface between firmware and drivers.  This
> set of headers are bundled with each flavor OS, and we are constantly
> providing update files when changes occur.
> 
> With respect to mpi_log_fc.h - this defines the loginfo for fibre channel
> protocal.  This is a easy lookup to for LSI Logic customers to better
> understand the kind of errors returned from firmware, and help reduce number
> of support generated request, as the end user can merely lookup the unqiue
> id in the header file.    mpi_inb.h, is header for fibre channel protocal
> definii
> ng the inband-management interface, and maybe implemented some day.

This is not the criteria for keeping source files in the tree,
they really have to be used to stay there.

If you want to document the error codes and other interfaces, publish
the programming manual for your hardware on a web site.

Sorry if you don't like this, but the linux kernel is about more than
your driver and your needs, it's about the needs of maintaining a huge
behemoth source tree in some sane manner and part of achieving that
goal is important tasks such as eliminating unused code and source
files.
