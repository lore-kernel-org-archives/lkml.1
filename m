Return-Path: <linux-kernel-owner+w=401wt.eu-S1760248AbZFPRY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760248AbZFPRY1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 13:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756631AbZFPRYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 13:24:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40700 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211AbZFPRYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 13:24:18 -0400
Date: Tue, 16 Jun 2009 13:24:18 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Greg KH <gregkh@suse.de>
Cc: Kyle McMartin <kyle@mcmartin.ca>, linux-kernel@vger.kernel.org,
       linux-parisc@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: Re: [PATCH 56/64] parisc: remove driver_data direct access of
	struct device
Message-ID: <20090616172418.GB15952@bombadil.infradead.org>
References: <20090616051351.GA23627@kroah.com> <1245131213-24168-56-git-send-email-gregkh@suse.de> <20090616151524.GA15952@bombadil.infradead.org> <20090616162524.GF26879@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616162524.GF26879@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 09:25:24AM -0700, Greg KH wrote:
> On Tue, Jun 16, 2009 at 11:15:24AM -0400, Kyle McMartin wrote:
> > On Mon, Jun 15, 2009 at 10:46:45PM -0700, Greg Kroah-Hartman wrote:
> > > In the near future, the driver core is going to not allow direct access
> > > to the driver_data pointer in struct device.  Instead, the functions
> > > dev_get_drvdata() and dev_set_drvdata() should be used.  These functions
> > > have been around since the beginning, so are backwards compatible with
> > > all older kernel versions.
> > > 
> > > Cc: linux-parisc@vger.kernel.org
> > > Cc: Helge Deller <deller@gmx.de>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > Acked-by: Kyle McMartin <kyle@mcmartin.ca>
> > 
> > Do you want to push it along with the rest of them, or would you like me
> > to apply it?
> 
> This was sent a while ago, and is going to Linus right now.  So if you
> want to also add it to your tree, so that it is sure to not get lost,
> that is fine with me :)
> 

Ah, it probably already was, but I've been so busy in the last month or
two that I missed sending anything after .30-rc$early. (I only asked
because Linus wasn't on the CC so I figured it was out for review
again, or something.)

cheers, Kyle
