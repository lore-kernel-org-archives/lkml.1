Return-Path: <linux-kernel-owner+w=401wt.eu-S1763071AbZDBWNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763071AbZDBWNf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 18:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756776AbZDBWN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 18:13:27 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33641 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755878AbZDBWN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 18:13:26 -0400
Message-ID: <49D5387B.2080200@garzik.org>
Date: Thu, 02 Apr 2009 18:13:15 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Rees <drees76@gmail.com>, Janne Grunau <j@jannau.net>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <20090325183011.GN32307@mit.edu>	<alpine.LFD.2.00.0903251622420.3032@localhost.localdomain>	<20090326171148.9bf8f1ec.akpm@linux-foundation.org>	<alpine.LFD.2.00.0903261723250.3994@localhost.localdomain>	<20090326174704.cd36bf7b.akpm@linux-foundation.org>	<alpine.LFD.2.00.0903261752110.3994@localhost.localdomain>	<20090326182519.d576d703.akpm@linux-foundation.org>	<20090401210337.GB3797@csclub.uwaterloo.ca>	<20090402110532.GA5132@aniel>	<20090402090912.cac200bb.akpm@linux-foundation.org>	<72dbd3150904020933y515c7185p5726323c430c339b@mail.gmail.com> <20090402095139.c2ff4f06.akpm@linux-foundation.org>
In-Reply-To: <20090402095139.c2ff4f06.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> ext3 _should_ handle this case fairly well nowadays - I thought we fixed that.
> However it would probably benefit from having the size of the block reservation
> window increased - use ioctl(EXT3_IOC_SETRSVSZ).  That way, each file gets a
> decent-sized hunk of disk "reserved" for its ongoing appending.  Other
> files won't come in and intermingle their blocks with it.

How big of a chore would it be, to use this code to implement 
i_op->fallocate() for ext3, I wonder?

	Jeff


