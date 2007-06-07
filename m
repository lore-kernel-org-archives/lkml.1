Return-Path: <linux-kernel-owner+w=401wt.eu-S932754AbXFGQAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932754AbXFGQAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 12:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765947AbXFGP7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 11:59:54 -0400
Received: from ns1.suse.de ([195.135.220.2]:56361 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765625AbXFGP7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 11:59:53 -0400
Date: Thu, 7 Jun 2007 08:59:53 -0700
From: Greg KH <gregkh@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Jones <pjones@redhat.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1
Message-ID: <20070607155953.GA17591@suse.de>
References: <20070606020737.4663d686.akpm@linux-foundation.org> <4667018D.7020407@googlemail.com> <1181168095.3612.4.camel@lov.localdomain> <4667C47C.2010207@googlemail.com> <1181206091.3625.9.camel@lov.localdomain> <4667D2DF.30207@googlemail.com> <1181228660.3625.23.camel@lov.localdomain> <46682385.1060802@redhat.com> <20070607154342.GA16911@suse.de> <20070607085200.f8d6e2d3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070607085200.f8d6e2d3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 08:52:00AM -0700, Andrew Morton wrote:
> On Thu, 7 Jun 2007 08:43:42 -0700 Greg KH <gregkh@suse.de> wrote:
> 
> > >  Fixed in mkinitrd-6.0.9-6 , which I'll build now and push to 
> > >  updates-testing.  Thanks for getting my attention here.
> > 
> > Great, Andrew, can you please reenable the block-device patch that is in
> > my tree now that the problem has been solved?
> 
> I think we're screwed, aren't we?  Everyone needs to upgrade mkinitrd to be
> able to boot the kernel?  Not viable :(
> 
> For example, what about my two-year-old yellowdog machine?

Enable CONFIG_SYSFS_DEPRECATED and it should all work just fine.  That's
what Michal said worked for him.

thanks,

greg k-h
