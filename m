Return-Path: <linux-kernel-owner+w=401wt.eu-S1751905AbZGaOVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbZGaOVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 10:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbZGaOVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 10:21:31 -0400
Received: from kroah.org ([198.145.64.141]:55469 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbZGaOVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 10:21:30 -0400
Date: Fri, 31 Jul 2009 07:17:28 -0700
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
Message-ID: <20090731141728.GA28260@kroah.com>
References: <alpine.LFD.2.01.0907281141070.3186@localhost.localdomain>
 <20090728195651.3a402a31@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.01.0907281158120.3186@localhost.localdomain>
 <20090728201553.0eb2d51d@lxorguk.ukuu.org.uk>
 <20090728195648.GA4833@kroah.com>
 <20090728204720.GF31679@mit.edu>
 <20090728210121.GB12155@kroah.com>
 <20090728220203.GI31679@mit.edu>
 <20090729004941.3a78d4b3@lxorguk.ukuu.org.uk>
 <20090731144901.09ba9ad3@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090731144901.09ba9ad3@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 31, 2009 at 02:49:01PM +0100, Alan Cox wrote:
> tar ball at
> 
> http://zeniv.linux.org.uk/~alan/ttydev.tar.gz
> 
> Series is in order of degree of working. It should all be sane down to
> vt-lockactive. The stuff down to tty-usb-serial-termiosbits has had some
> basic testing.
> 
> tty-usb-cleanup-open hangs still on the second open and is a work in
> progress but shows where the tty close side interface was going in order
> to remove all the posix logic from drivers.
> 
> beyond that is the last bits of the serial cleanup which are definitely
> "work in progress", and the f81216 helper which needs reworking into the
> drivers proper.

Thanks for providing this.  I'll pull these into my tree and then tell
Stephen about it for linux-next.

Thanks again for doing the tty work, it is much appreciated.

greg k-h
