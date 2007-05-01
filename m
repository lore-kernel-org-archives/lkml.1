Return-Path: <linux-kernel-owner+w=401wt.eu-S1423777AbXEAFAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423777AbXEAFAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 01:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423785AbXEAFAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 01:00:37 -0400
Received: from canuck.infradead.org ([209.217.80.40]:36376 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423777AbXEAFAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 01:00:36 -0400
Date: Mon, 30 Apr 2007 21:58:06 -0700
From: Greg KH <greg@kroah.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Chris Wright <chrisw@sous-sol.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] to something appropriate (was Re: 2.6.22 -mm merge
	plans)
Message-ID: <20070501045806.GA3697@kroah.com>
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <46368062.6000100@garzik.org> <20070430170919.45e4b42b.akpm@linux-foundation.org> <463688AD.1050903@garzik.org> <20070501004036.GS2819@sequoia.sous-sol.org> <46368DA5.7070003@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46368DA5.7070003@garzik.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 08:45:25PM -0400, Jeff Garzik wrote:
> Chris Wright wrote:
> > 2) you can add them
> > runtime in userspace (and for pcmcia too after patch in question is
> > applied), so we've historically avoided that kind of patch for -stable.
> 
> 
> Due to distro installer environments, and very poor support for making 
> dynamic PCI IDs persistent once added, what you describe is more of a 
> goal than reality.

But distros can easily add the device id to their kernel if needed, it
isn't something that the -stable tree shoud be accepting.  Otherwise, we
will be swamped with those types of patches...

thanks,

greg k-h
