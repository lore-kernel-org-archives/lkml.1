Return-Path: <linux-kernel-owner+w=401wt.eu-S1761977AbXGYFMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761977AbXGYFMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 01:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822AbXGYFMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 01:12:12 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:2608 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbXGYFML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 01:12:11 -0400
Date: Wed, 25 Jul 2007 07:12:08 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Andreas Micklei <andreas.micklei@ivistar.de>,
       Andreas Messer <andreas.messer@stud-mail.uni-wuerzburg.de>,
       linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: Re: [BUG] firewire: mass-storage i/o-problems
Message-ID: <20070725051208.GA13710@roarinelk.homelinux.net>
References: <200707222332.12270.andreas.messer@stud-mail.uni-wuerzburg.de> <46A3E973.6090701@s5r6.in-berlin.de> <20070723063741.GA32240@roarinelk.homelinux.net> <46A45B65.9000704@s5r6.in-berlin.de> <20070723084505.GB349@roarinelk.homelinux.net> <46A49244.9010402@s5r6.in-berlin.de> <20070723183336.GA3736@roarinelk.homelinux.net> <20070723184405.GB3736@roarinelk.homelinux.net> <46A6598B.5080004@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A6598B.5080004@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2007 at 09:56:59PM +0200, Stefan Richter wrote:
> Manuel Lauss wrote:
> > Actually, copying data to the disk while playing/seeking through a moviefile
> > which is also located on it is already enough. Forget the NFS thing...
> > 
> > Afterwards the firewire_sbp2 module has to be rmmod-ed and modprobed again
> > or it will continue to throw errors even for single reads.
> > 
> > I hope this helps tracking it down...
> 
> I tried this and similar tests on my main PC (PCIe based) and on an
> Athlon/KM266 PC, with 1394b and 1394a hardware.  Nothing happened,
> except for a single "status write for unknown orb", followed by command
> abort from which the disk immediately recovered.  I did many tests and
> it didn't happen again.  I.e. it's probable that the supposed bug
> happens here too, but very rarely.

I tried 2.6.23 in the meantime, it's *MUCH* harder to trigger; in fact
I had to skip through movies for ~10 minutes to get the orb timeout.
The disk was inaccessible for a few seconds then recovered fine.

> Could you (and everyone else who has repeated I/O errors with the new
> drivers, but not with the old drivers) test the attached patches, one
> patch at a time?  They apply to 2.6.22.

Will do.

Thanks,
	Manuel Lauss
