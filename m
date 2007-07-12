Return-Path: <linux-kernel-owner+w=401wt.eu-S933477AbXGLNnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933477AbXGLNnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 09:43:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762476AbXGLNmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 09:42:54 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50524 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761363AbXGLNmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 09:42:53 -0400
Date: Thu, 12 Jul 2007 06:42:43 -0700
From: Mike Anderson <andmike@us.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: johnpol@2ka.mipt.ru, akpm@linux-foundation.org, agk@redhat.com,
       dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [2.6.23 PATCH 13/18] dm: netlink
Message-ID: <20070712134242.GA1671@us.ibm.com>
References: <20070711142712.e646995b.akpm@linux-foundation.org> <20070711233736.GA29241@us.ibm.com> <20070712081028.GB25699@2ka.mipt.ru> <20070712.032727.07453420.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070712.032727.07453420.davem@davemloft.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> wrote:
> From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
> Date: Thu, 12 Jul 2007 12:10:29 +0400
> 
> > On Wed, Jul 11, 2007 at 04:37:36PM -0700, Mike Anderson (andmike@us.ibm.com) wrote:
> > > > > --- linux.orig/include/linux/netlink.h	2007-07-11 21:37:31.000000000 +0100
> > > > > +++ linux/include/linux/netlink.h	2007-07-11 21:37:50.000000000 +0100
> > > > > @@ -21,7 +21,7 @@
> > > > >  #define NETLINK_DNRTMSG		14	/* DECnet routing messages */
> > > > >  #define NETLINK_KOBJECT_UEVENT	15	/* Kernel messages to userspace */
> > > > >  #define NETLINK_GENERIC		16
> > > > > -/* leave room for NETLINK_DM (DM Events) */
> > > > > +#define NETLINK_DM		17	/* Device Mapper */
> > > > >  #define NETLINK_SCSITRANSPORT	18	/* SCSI Transports */
> > > > >  #define NETLINK_ECRYPTFS	19
> > > > 
> > > > Have the net guys checked this?  
> > > 
> > > No. The support is a derivative of the netlink support in
> > > scsi_transport_iscsi.c.
> > 
> > I'm not sure about all net guys, but the first question rised after
> > reading this - why do you want special netlink family and do not want to
> > use interfaces created on top of - like connector and genetlink?
> 
> I agree, there is really no reason to not at least use
> genetlink.

ok, I will switch over to using genetlink.

-andmike
--
Michael Anderson
andmike@us.ibm.com
