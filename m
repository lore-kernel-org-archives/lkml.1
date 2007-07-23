Return-Path: <linux-kernel-owner+w=401wt.eu-S1762770AbXGWIpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762770AbXGWIpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 04:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756731AbXGWIpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 04:45:10 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:3016 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363AbXGWIpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 04:45:08 -0400
Date: Mon, 23 Jul 2007 10:45:06 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Andreas Messer <andreas.messer@stud-mail.uni-wuerzburg.de>,
       linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: Re: [BUG] firewire: mass-storage i/o-problems
Message-ID: <20070723084505.GB349@roarinelk.homelinux.net>
References: <200707222332.12270.andreas.messer@stud-mail.uni-wuerzburg.de> <46A3E973.6090701@s5r6.in-berlin.de> <20070723063741.GA32240@roarinelk.homelinux.net> <46A45B65.9000704@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A45B65.9000704@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jul 23, 2007 at 09:40:21AM +0200, Stefan Richter wrote:
> Manuel Lauss wrote:
> > I too experience these bugs with the new fw stack; this time with a TI
> > OHCI-1394a combo chip in 2 different laptops and a Via 1394 pci addon card.
> > The target is a an external hd enclosure with an Oxford Semi chip.
> 
> Thanks for the info.  Then there is definitely a driver problem.  It is
> essential that I (and Kristian) find a way to reproduce it.

I noticed the failures start when there are 2 concurrent disk accesses
(copy something from fw disk on shell 1 and it runs fine; start to
copy something TO the fw disk on shell 2 and a "management write failed"
error appears after 1-2 sec. with the orb timeout after a looong time)
I didn't investigate it further and switched back to the old stack.

Thanks,
	Manuel Lauss
