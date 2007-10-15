Return-Path: <linux-kernel-owner+w=401wt.eu-S932978AbXJORpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978AbXJORpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 13:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765517AbXJORpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 13:45:10 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:42623 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764854AbXJORpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 13:45:08 -0400
Date: Mon, 15 Oct 2007 18:45:05 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Adrian Bunk <bunk@kernel.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: -git mips defconfig compile error
Message-ID: <20071015174505.GA19857@linux-mips.org>
References: <20071014131948.GF4211@stusta.de> <20071015095535.GB9896@linux-mips.org> <Pine.LNX.4.64N.0710151715200.16262@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64N.0710151715200.16262@blysk.ds.pg.gda.pl>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 05:19:43PM +0100, Maciej W. Rozycki wrote:

> > The logo.c bit I've sent out a few weeks ago so I'm just waiting for that
> > patch to resurface at the other end of the wormhole.
> 
>  Hmm, I would have waited for this to happen before committing the change 
> depending on it not to keep things known-broken then...  That's what I do 
> with my bits, e.g. I have an update to platform code waiting till 
> sb1250-mac.c changes come over here.

Na, much more trivial.  After a little looking into what went wrong I
found that I meant to strip only the jazzsonic segment because of another
jazzsonic patch from Fleedwood.  But I stripped the logo.c bit as well.

  Ralf
