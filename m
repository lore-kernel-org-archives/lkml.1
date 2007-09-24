Return-Path: <linux-kernel-owner+w=401wt.eu-S1757546AbXIXKuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546AbXIXKuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 06:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753466AbXIXKuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 06:50:44 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:51350 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbXIXKun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 06:50:43 -0400
X-Originating-Ip: 72.143.66.27
Date: Mon, 24 Sep 2007 06:49:44 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Jaswinder Singh <jaswinderlinux@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22.7 autoconf.h is screwed up
In-Reply-To: <3f9a31f40709240346o21eb48b8u518a1af72faa9e8f@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0709240647140.1295@localhost.localdomain>
References: <3f9a31f40709240320mb213a7an87cee8bf5517d7f7@mail.gmail.com> 
 <Pine.LNX.4.64.0709240625140.31104@localhost.localdomain> 
 <3f9a31f40709240335w441699b5y366211baeebde871@mail.gmail.com> 
 <Pine.LNX.4.64.0709240637140.791@localhost.localdomain>
 <3f9a31f40709240346o21eb48b8u518a1af72faa9e8f@mail.gmail.com>
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

On Mon, 24 Sep 2007, Jaswinder Singh wrote:

> hello rday,
>
> On 9/24/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> > On Mon, 24 Sep 2007, Jaswinder Singh wrote:
> >
> > > hello rday,
> > >
> > > In my view autoconf.h is the index of kernel you are using. By
> > > reading autoconf.h you will know what Architecture, drivers is
> > > selected.
> > >
> > > For example, If we are using some ARM based board, If you give me
> > > your autoconf.h , I can replicate same environment as yours. If it
> > > is not properly formatted it is very difficult to read and come to
> > > some conclusion.
> >
> > no, the proper thing to do is give someone your .config file if you
> > want them to reproduce your configuration, and leave autoconf.h out of
> > it.
> >
>
> yes, you are right. So autoconf.h is obsolete and replaced by .config
> . And now autoconf.h looks so funny and scary that no body dares to
> open autoconf.h in future ;-)

no, you're missing the point.  the .config file represents your
selection of kernel options, it's what you can hand to someone if they
want to reproduce your configuration.  autoconf.h, on the other hand,
is automatically generated from your .config file once you start the
build process.  it is in no way "obsolete", it's used by the build
process -- it's just not meant to be manipulated by users.

don't worry about autoconf.h, just leave it alone -- the build process
takes care of it.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
