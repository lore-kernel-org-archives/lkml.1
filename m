Return-Path: <linux-kernel-owner+w=401wt.eu-S1752706AbZG3XQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706AbZG3XQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 19:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbZG3XQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 19:16:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43327 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750994AbZG3XQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 19:16:22 -0400
Date: Fri, 31 Jul 2009 00:16:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Theodore Tso <tytso@mit.edu>, Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
Message-ID: <20090731001621.6d5a1da9@lxorguk.ukuu.org.uk>
In-Reply-To: <20090729004941.3a78d4b3@lxorguk.ukuu.org.uk>
References: <20090728174213.5e927428@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907280944150.3186@localhost.localdomain>
	<20090728180649.596c5412@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907281141070.3186@localhost.localdomain>
	<20090728195651.3a402a31@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907281158120.3186@localhost.localdomain>
	<20090728201553.0eb2d51d@lxorguk.ukuu.org.uk>
	<20090728195648.GA4833@kroah.com>
	<20090728204720.GF31679@mit.edu>
	<20090728210121.GB12155@kroah.com>
	<20090728220203.GI31679@mit.edu>
	<20090729004941.3a78d4b3@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'll fish them out tomorrow. What is in the -next tree is only some of
> the bits.
> 
> We still have races on the USB side too btw I put a frequency generator
> on the carrier line of my pl2303 with an app continually opening the
> port and it oopses after about 10 minutes. On the bright side so does
> 2.6.29, 2.6.27 ....

Just an update - I've not posted them yet as I've been putting the
various branches into some kind of sane order with the tested stuff first
and the "in progress" serial -> tty_port stuff last.

