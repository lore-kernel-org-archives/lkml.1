Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395Ab0AOXzY (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 18:55:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758653Ab0AOXzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 18:55:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60090 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758674Ab0AOXzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 18:55:19 -0500
Date: Fri, 15 Jan 2010 15:54:25 -0800
From: Greg KH <gregkh@suse.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, KMoorman@transy.edu,
        w.sang@pengutronix.de, ken_kawasaki@spring.nifty.jp,
        davem@davemloft.net, Andrew Morton <akpm@osdl.org>,
        alan@lxorguk.ukuu.org.uk
Subject: Re: serial_cs: oxsemi quirk breaks resume
Message-ID: <20100115235425.GB20493@suse.de>
References: <20091110075410.GA6157@ucw.cz>
 <20100115200100.GC1345@ucw.cz>
 <20100115235333.GA20493@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100115235333.GA20493@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 15, 2010 at 03:53:33PM -0800, Greg KH wrote:
> On Fri, Jan 15, 2010 at 09:01:00PM +0100, Pavel Machek wrote:
> > On Tue 2009-11-10 08:54:10, Pavel Machek wrote:
> > > 
> > > Quirk is applied on all cards with given manfid (is it that
> > > correct?). Unfortunately, that quirk breaks resume on zaurus with
> > > billionton bluetooth card inserted: c950ctrl is 0 and outb() faults.
> > > 
> > > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > 
> > I believe this patch got enough acks and is waiting in the tree
> > somewhere (greg?) (possibly with slightly different changelog), but I
> > don't see it in 33-rc4. Could it get pushed? It is quite simple
> > bugfix, and is important for my zaurus...  Pavel
> 
> I thought others complained about it.
> 
> If not, care to resend it to me, with the acks added to it, so that I
> can forward it on?

Oh nevermind, it's in my tree already, I'll include it in the next round
of patches to go to Linus (looking like Monday now, too late for
today...)

thanks,

greg k-h
