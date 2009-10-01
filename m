Return-Path: <linux-kernel-owner+w=401wt.eu-S1754985AbZJAPgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbZJAPgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 11:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754725AbZJAPg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 11:36:28 -0400
Received: from kroah.org ([198.145.64.141]:34204 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368AbZJAPg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 11:36:27 -0400
Date: Thu, 1 Oct 2009 08:30:17 -0700
From: Greg KH <greg@kroah.com>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 00/48] 2.6.27.32-stable review
Message-ID: <20091001153017.GA6058@kroah.com>
References: <200909112223.n8BMMSHG002530@hera.kernel.org>
 <20090916210956.GB24567@kroah.com>
 <4AB387E3.6030709@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB387E3.6030709@imap.cc>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 03:15:15PM +0200, Tilman Schmidt wrote:
> Am 16.09.2009 23:09 schrieb Greg KH:
> > Can you send me what you need applied to the latest 2.6.27-stable tree
> > to fix this up so we can finally resolve this?
> 
> The patch that should have been applied is here:
> 
> http://patchwork.kernel.org/patch/13845/
> 
> I'm including it below for completeness.
> 
> The patch that was applied to 2.6.27-stable instead is this:
> 
> http://patchwork.kernel.org/patch/20855/
> (commit 221418f9a25cd96aff99d6aba41c177f6eb00853)
> 
> The difference is in blob 5 which inserts the new code at the wrong place.
> I have no idea who or what caused that change.
> 
> So commit 221418f9a25cd96aff99d6aba41c177f6eb00853 should be reverted and
> my original patch below applied instead. The patch by Stefan Bader is
> equivalent to that but additionally backports two pr_err() calls from
> mainline.

I took Stefan's patch as it was simpler.  Let me know if the problem is
still present.

thanks,

greg k-h
