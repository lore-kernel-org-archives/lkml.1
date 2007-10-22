Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbXJVTBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbXJVTBD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 15:01:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbXJVTAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 15:00:54 -0400
Received: from mail.queued.net ([207.210.101.209]:1462 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231AbXJVTAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 15:00:53 -0400
Date: Mon, 22 Oct 2007 15:00:15 -0400
From: Andres Salomon <dilinger@queued.net>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: kbuild-devel@lists.sourceforge.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: UNS: Re: [PATCH] kconfig: add *_silentdefconfig feature for
 config targets
Message-ID: <20071022150015.72d9ebef@ephemeral>
In-Reply-To: <Pine.LNX.4.64.0708211809110.1817@scrub.home>
References: <20070820204020.7cde776e.dilinger@queued.net>
	<Pine.LNX.4.64.0708211717180.1817@scrub.home>
	<20070821114129.fe2737b4.dilinger@queued.net>
	<Pine.LNX.4.64.0708211809110.1817@scrub.home>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2007 18:21:55 +0200 (CEST)
Roman Zippel <zippel@linux-m68k.org> wrote:

> Hi,
> 
> On Tue, 21 Aug 2007, Andres Salomon wrote:
> 
> > > I would really like to avoid another input mode.
> > > I think it be better to implement this as a combination of "-s -D 
> > > <default>" and the silent mode is adjusted to read another config
> > > instead of .config if defconfig_file is set.
> > > 
> > 
> > As would I; however, that requires using getopt() (or equivalent).
> > I wasn't sure if there was some opposition to this..
> 
> I'm not sure how getopt() would change much (besides changing the
> "if" to a "while"), but I don't really mind either way.
> 

It would allow more flexibilty; being able to specify multiple
arguments, for example.  Unfortunately, I haven't had much time to work
on this, but I did do the getopt patch.  Since it's been sitting on my
drive for a while, I should probably send it out before I lose it.  :)
