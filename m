Return-Path: <linux-kernel-owner+w=401wt.eu-S1754482AbZDNC1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbZDNC1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 22:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbZDNC0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 22:26:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39460 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbZDNC0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 22:26:51 -0400
Date: Mon, 13 Apr 2009 19:24:18 -0700
From: Greg KH <gregkh@suse.de>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
Subject: Re: [PATCH 0/3] Fix rt28{6,7}0sta to use firmware loader
Message-ID: <20090414022418.GA17760@suse.de>
References: <1239589992.18110.117.camel@deadeye.i.decadent.org.uk> <20090413024445.GA12860@suse.de> <1239667961.18110.166.camel@deadeye.i.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239667961.18110.166.camel@deadeye.i.decadent.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 01:12:41AM +0100, Ben Hutchings wrote:
> On Sun, 2009-04-12 at 19:44 -0700, Greg KH wrote:
> > On Mon, Apr 13, 2009 at 03:33:12AM +0100, Ben Hutchings wrote:
> > > Greg,
> > > 
> > > The Ralink drivers rt2860sta, rt2870sta and rt3070sta contain non-free
> > > firmware which should be distributed separately.
> > 
> > Where is it now distributed?  I don't want to break people's machines
> > that were working before this patch is applied.
> 
> The canonical source is
> <http://www.ralinktech.com/ralink/Home/Support/Linux.html>

Yes, and that is where I got the code that is in the driver tree that
you are objecting to now :)

> The files are now also in the Debian repository for our firmware-nonfree
> package and in <http://git.decadent.org.uk/git/linux-firmware.git>.
> I've asked David Woodhouse to pull from that into his linux-firmware.git
> so that they get into other distros.

When David pulls it into his tree, and does a release, please let me
know and I'll be glad to accept your patch.  Until then, I can't accept
this patch as it would break people's machines that were previously
working.

thanks,

greg k-h
