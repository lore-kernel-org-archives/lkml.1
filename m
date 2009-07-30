Return-Path: <linux-kernel-owner+w=401wt.eu-S1753218AbZG3XZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbZG3XZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 19:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753202AbZG3XZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 19:25:55 -0400
Received: from kroah.org ([198.145.64.141]:57959 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682AbZG3XZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 19:25:44 -0400
Date: Thu, 30 Jul 2009 16:24:43 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
Message-ID: <20090730232443.GA20367@kroah.com>
References: <alpine.LFD.2.01.0907281141070.3186@localhost.localdomain>
 <20090728195651.3a402a31@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.01.0907281158120.3186@localhost.localdomain>
 <20090728201553.0eb2d51d@lxorguk.ukuu.org.uk>
 <20090728195648.GA4833@kroah.com>
 <20090728204720.GF31679@mit.edu>
 <20090728210121.GB12155@kroah.com>
 <20090728220203.GI31679@mit.edu>
 <20090729004941.3a78d4b3@lxorguk.ukuu.org.uk>
 <20090731001621.6d5a1da9@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090731001621.6d5a1da9@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 31, 2009 at 12:16:21AM +0100, Alan Cox wrote:
> > I'll fish them out tomorrow. What is in the -next tree is only some of
> > the bits.
> > 
> > We still have races on the USB side too btw I put a frequency generator
> > on the carrier line of my pl2303 with an app continually opening the
> > port and it oopses after about 10 minutes. On the bright side so does
> > 2.6.29, 2.6.27 ....
> 
> Just an update - I've not posted them yet as I've been putting the
> various branches into some kind of sane order with the tested stuff first
> and the "in progress" serial -> tty_port stuff last.

Thanks for the update, I appreciate it.

greg k-h
