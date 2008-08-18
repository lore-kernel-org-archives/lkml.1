Return-Path: <linux-kernel-owner+w=401wt.eu-S1753883AbYHRDw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbYHRDw2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 23:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbYHRDv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 23:51:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:34764 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbYHRDvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 23:51:55 -0400
Date: Sun, 17 Aug 2008 20:48:51 -0700
From: Greg KH <greg@kroah.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       rusty@rustcorp.com.au
Subject: Re: linux-next: Tree for August 14 (sysfs/acpi errors)
Message-ID: <20080818034851.GB30843@kroah.com>
References: <3ae72650808150427q364842ccicf0a0978b30ca98c@mail.gmail.com> <20080815085836.67e420f1.randy.dunlap@oracle.com> <1218854219.3629.30.camel@lgn.site> <48A64235.2030108@linux.intel.com> <1218856798.3629.45.camel@lgn.site> <48A64E0A.8090408@linux.intel.com> <20080816044714.GA19886@kroah.com> <48A78D4A.70609@linux.intel.com> <20080817034051.GA26849@kroah.com> <87hc9kxpp8.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hc9kxpp8.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 17, 2008 at 05:53:07AM +0200, Andi Kleen wrote:
> Greg KH <greg@kroah.com> writes:
> >> No!
> >
> > What you are doing here is wrong, trying to create two files with the
> > same name.  You just should not be doing that at all, it's that simple.
> > Fix the broken code/link order, don't paper it over in the sysfs layer.
> 
> Sorry, but relying on link order for anything is a mistake. It is subtle
> and fragile and just means it'll eventually break again because it's
> near impossible to properly maintain.

We rely on link order for all sorts of things, this isn't new at all.

thanks,

greg k-h
