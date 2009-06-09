Return-Path: <linux-kernel-owner+w=401wt.eu-S1759385AbZFIImh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385AbZFIImh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 04:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbZFIIma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 04:42:30 -0400
Received: from kroah.org ([198.145.64.141]:36854 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213AbZFIIm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 04:42:29 -0400
Date: Tue, 9 Jun 2009 01:18:30 -0700
From: Greg KH <greg@kroah.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>, stable@kernel.org
Subject: Re: [stable] [patch 29/51] mac80211: pid, fix memory corruption
Message-ID: <20090609081830.GA8347@kroah.com>
References: <20090514223235.348540705@mini.kroah.org> <20090514223525.042094922@mini.kroah.org> <4A0D0A76.7040806@gmail.com> <20090515144901.GB27812@suse.de> <4A0DE362.4010903@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0DE362.4010903@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 15, 2009 at 11:49:22PM +0200, Jiri Slaby wrote:
> CCs chopped.
> 
> On 05/15/2009 04:49 PM, Greg KH wrote:
> > On Fri, May 15, 2009 at 08:23:50AM +0200, Jiri Slaby wrote:
> >> note that you were about to drop this one now because of waiting for a
> >> fixup which is not upstream so far. Did anything change?
> > 
> > Hm, no, I dropped a different patch,
> > 	mac80211-minstrel-fix-memory-corruption.patch
> > did I drop the wrong one?
> 
> The aforementioned fix finally did it in. Please, apply
> 8e532175277d9a5eae49768ed086555081f741a7
> (mac80211: minstrel, fix memory corruption)
> 
> 6909268dc93ae4b0b8e1ebb4b2fa70b1a47dd347
> (mac80211: pid, fix memory corruption)
> 
> 621ad7c96aa138cfeab53cd4debc5a4e08b2189b
> (mac80211: avoid NULL ptr deref when finding max_rates in PID and minstrel)
> 
> Thanks and sorry for the chaos.

Heh, no problem.  All of these are now queued up.

thanks,

greg k-h
