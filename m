Return-Path: <linux-kernel-owner+w=401wt.eu-S1755776AbXKSXA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776AbXKSXA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 18:00:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754896AbXKSXAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 18:00:44 -0500
Received: from cantor.suse.de ([195.135.220.2]:37634 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754779AbXKSXAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 18:00:43 -0500
Date: Mon, 19 Nov 2007 14:52:10 -0800
From: Greg KH <gregkh@suse.de>
To: David Miller <davem@davemloft.net>
Cc: david-b@pacbell.net, stern@rowland.harvard.edu, zwane@arm.linux.org.uk,
       tytso@mit.edu, torvalds@linux-foundation.org, stable@kernel.org,
       reviews@ml.cw.f00f.org, rdunlap@xenotime.net, mkrufky@linuxtv.org,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       jmforbes@linuxtx.org, dely.l.sy@intel.com, davej@redhat.com,
       chuckw@quantumlinux.com, cebbert@redhat.com, cavokz@gmail.com,
       alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
Subject: Re: [patch 19/26] USB: mutual exclusion for EHCI init and port
	resets
Message-ID: <20071119225210.GA23798@suse.de>
References: <Pine.LNX.4.44L0.0711191403400.3005-100000@iolanthe.rowland.org> <20071119195955.B0C482214F3@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <20071119.143241.165308264.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119.143241.165308264.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2007 at 02:32:41PM -0800, David Miller wrote:
> From: David Brownell <david-b@pacbell.net>
> Date: Mon, 19 Nov 2007 11:59:55 -0800
> 
> > > This addition certainly won't hurt.  Did we ever get any feedback as to 
> > > whether it actually helped?
> > 
> > ISTR that davem refused to try it, after reporting an
> > intermittent failure on the original patch (which only
> > addresses one end of that hardware race).
> > 
> > So, no ... but given we know that closing only one side
> > of the race isn't quite enough, I think we need it anyway.
> 
> I think we should put all these changes in because at a minimum
> it's a step in the right direction even if it doesn't close
> the hole %100.
> 
> So please let's merge the mutex and the msleep() change in
> ASAP, thanks.

The msleep one is queued up for the next Linus pull, and after it goes
in, I'll add it to the -stable trees as well.

thanks,

greg k-h
