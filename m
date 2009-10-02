Return-Path: <linux-kernel-owner+w=401wt.eu-S1756624AbZJBQNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624AbZJBQNQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 12:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755903AbZJBQNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 12:13:15 -0400
Received: from kroah.org ([198.145.64.141]:45168 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755882AbZJBQNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 12:13:14 -0400
Date: Fri, 2 Oct 2009 09:10:49 -0700
From: Greg KH <greg@kroah.com>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, dm-devel@redhat.com,
       Evgeniy Polyakov <zbr@ioremap.net>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH 0/8] SECURITY ISSUE with connector
Message-ID: <20091002161048.GA23044@kroah.com>
References: <1254487211-11810-1-git-send-email-philipp.reisner@linbit.com>
 <20091002135859.GA9383@kroah.com>
 <200910021754.12940.philipp.reisner@linbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910021754.12940.philipp.reisner@linbit.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 02, 2009 at 05:54:12PM +0200, Philipp Reisner wrote:
> > On Fri, Oct 02, 2009 at 02:40:03PM +0200, Philipp Reisner wrote:
> > > Affected: All code that uses connector, in kernel and out of mainline
> > >
> > > The connector, as it is today, does not allow the in kernel receiving
> > > parts to do any checks on privileges of a message's sender.
> >
> > So, assume I know nothing about the connector architecture, what does
> > this mean in a security context?
> >
> 
> Think of the connector as a layer on top of netlink that allows more
> than a hard coded number of subsystems to use netlink.
> 
> Netlink is used e.g. to modify routing tables in the kernel.
> 
> As it is today, subsystem utilising the connector can not examine
> the capabilities of the user/program that sent the netlink message.
> 
> If the same would be true for netlink, than every unprivileged user
> could change the routing tables on your box.
> 
> > > I know, there are not many out there that like connector, but as
> > > long as it is in the kernel, we have to fix the security issues it has!
> >
> > And what specifically are the security issues?
> >
> 
> unprivileged users can trigger operations that are supposed to be only
> accessible to users having CAP_SYS_ADMIN (or some other CAP_XXX)

Ok, but it doesn't look like there are that many connector operations
right now, right?

Anyway, I have no objection to the patches, and figure they should go
through David's network tree.

thanks,

greg k-h
