Return-Path: <linux-kernel-owner+w=401wt.eu-S1763629AbXKOQcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763629AbXKOQcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 11:32:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbXKOQcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 11:32:23 -0500
Received: from ns2.suse.de ([195.135.220.15]:51588 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757320AbXKOQcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 11:32:23 -0500
Date: Thu, 15 Nov 2007 08:32:01 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 08/16] skge: fix ram buffer size calculation
Message-ID: <20071115163201.GA24087@suse.de>
References: <20071115060353.071060513@mini.kroah.org> <20071115064037.GH18951@kroah.com> <alpine.LFD.0.9999.0711150810130.2786@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0711150810130.2786@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2007 at 08:11:30AM -0800, Linus Torvalds wrote:
> 
> 
> On Wed, 14 Nov 2007, Greg KH wrote:
> > 
> > -stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > From: Stephen Hemminger <shemminger@linux-foundation.org>
> > 
> > patch 7fb7ac241162dc51ec0f7644d4a97b2855213c32 in mainline.
> > 
> > This fixes problems with transmit hangs on older fiber based SysKonnect boards.
> > 
> > Adjust ram buffer sizing calculation to make it correct on all boards
> > and make it like the code in sky2 driver.
> 
> This one is getting reverted in mainline in about five minutes (unless I 
> find an email from Stephen to address the reported regression - I haven't 
> gone through all my emails yet), so I don't think it should make it into 
> stable.

Thanks for letting me know which patch is causing the problem, I just
got another report of the skge driver not working with all of these
patches applied.

It looks like I'll just drop this one from the patch list, unless
Stephen has a better idea.

thanks,

greg k-h
