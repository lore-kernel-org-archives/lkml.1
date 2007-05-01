Return-Path: <linux-kernel-owner+w=401wt.eu-S1423014AbXEAAmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423014AbXEAAmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 20:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423405AbXEAAmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 20:42:42 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:38067 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423014AbXEAAml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 20:42:41 -0400
Date: Mon, 30 Apr 2007 17:40:36 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] to something appropriate (was Re: 2.6.22 -mm merge plans)
Message-ID: <20070501004036.GS2819@sequoia.sous-sol.org>
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <46368062.6000100@garzik.org> <20070430170919.45e4b42b.akpm@linux-foundation.org> <463688AD.1050903@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <463688AD.1050903@garzik.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeff Garzik (jeff@garzik.org) wrote:
> Andrew Morton wrote:
> > Yeah, a new-id patch is a pretty critical bugfix if you happen to have that
> > hardware.  I'll get all these into 2.6.22 by whatever means and will adopt
> > your advice in future.
> > 
> > Probably these should go into -stable too, but I don't know what
> > Greg&Chris's position is on new device IDs.
> 
> I don't know either.  But a one-line ID patch is pretty painless 
> considering the gain, so I would vote for stable@kernel.org taking such 
> patches.
> 
> If it's more than one line added per ID though, NAK for -stable, IMO...

Well, there's 2 issues here.  1) the patch in question is not -stable
material (the patch name is a bit misleading).  2) you can add them
runtime in userspace (and for pcmcia too after patch in question is
applied), so we've historically avoided that kind of patch for -stable.

thanks,
-chris
