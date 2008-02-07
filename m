Return-Path: <linux-kernel-owner+w=401wt.eu-S934147AbYBGVyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934147AbYBGVyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:54:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761026AbYBGVxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 16:53:51 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55400 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754475AbYBGVxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 16:53:49 -0500
Date: Thu, 7 Feb 2008 13:53:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Stephen Neuendorffer" <stephen.neuendorffer@xilinx.com>
Cc: grant.likely@secretlab.ca, jirislaby@gmail.com,
       linux-kernel@vger.kernel.org, paulus@samba.org, galak@gate.crashing.org,
       benh@kernel.crashing.org, torvalds@linux-foundation.org
Subject: Re: Xilinx: hwicap driver comments
Message-Id: <20080207135341.04e5652a.akpm@linux-foundation.org>
In-Reply-To: <20080207213512.36FA991807D@mail185-dub.bigfish.com>
References: <47AB6552.7040503@gmail.com>
	<20080207124203.147ce300.akpm@linux-foundation.org>
	<fa686aa40802071254p172103f0w423f4591583ca3ef@mail.gmail.com>
	<20080207132106.ec5ebf1d.akpm@linux-foundation.org>
	<fa686aa40802071331l16b40bacm4a7ca01a7219f1fb@mail.gmail.com>
	<20080207213512.36FA991807D@mail185-dub.bigfish.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2008 13:35:09 -0800
"Stephen Neuendorffer" <stephen.neuendorffer@xilinx.com> wrote:

> > > It seems wrong that the signoff trail for that patch didn't actually
> > > reflect reality - it should have had both Josh's and Paul's
> signoffs.  That
> > > would require that the changelog be altered during git->git
> transfers which
> > > I expect is just incompatible with the way git works (as far as I
> dimly
> > > understand it).
> 
> I'm rather new to all this and still (to some extent) trying to figure
> out what is expected.

We're all still trying to figure it out, really.  We've gone and made it
awfully easy to get code into the kernel nowadays.  Perhaps too easy.  I'm
presently having a little campaign of watching what's going on a bit more
closely, and ecouraging people to make it easier for others to see what's
going on, should they choose to do so.

I'm hoping that by the time we're developing 2.6.26 there will be a unified
git tree (aka linux-next) (basically all the git and quilt trees from -mm)
for people to look at and play with.  That'll improve our pre-merge test
coverage, but won't do much to improve review.  And it won't do anything to
improve our post-merge bugfixing.

> Maybe what is needed is git pull --ack?

I'm also hoping/expecting/planning that if someone tries to merge a patch
into mainline, and that patch hasn't been in linux-next for "long enough",
flags will wave and lights will flash and we can get to take a closer look
at why it was so late and whether it's OK.
