Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab0BEQuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 11:50:06 -0500
Received: from cantor.suse.de ([195.135.220.2]:60183 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479Ab0BEQuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 11:50:03 -0500
Date: Fri, 5 Feb 2010 08:50:24 -0800
From: Greg KH <gregkh@suse.de>
To: David Miller <davem@davemloft.net>
Cc: hadi@cyberus.ca, s.L-H@gmx.de, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: patch net-restore-ip-source-validation.patch added to
	2.6.32-stable tree
Message-ID: <20100205165024.GA28400@suse.de>
References: <201002041931.40493.s.L-H@gmx.de> <1265308725.4651.14.camel@bigi> <1265313056.4651.18.camel@bigi> <20100204.120345.51673241.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100204.120345.51673241.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 04, 2010 at 12:03:45PM -0800, David Miller wrote:
> From: jamal <hadi@cyberus.ca>
> Date: Thu, 04 Feb 2010 14:50:56 -0500
> 
> > Ok, I was able to reproduce it finally. This fixes it:
> > 
> > ---
> > diff --git a/kernel/sysctl_check.c b/kernel/sysctl_check.c
> > index b6e7aae..469193c 100644
> > --- a/kernel/sysctl_check.c
> > +++ b/kernel/sysctl_check.c
> > @@ -220,6 +220,7 @@ static const struct trans_ctl_table
> > trans_net_ipv4_conf_vars_table[] = {
> >         { NET_IPV4_CONF_PROMOTE_SECONDARIES,    "promote_secondaries" },
> >         { NET_IPV4_CONF_ARP_ACCEPT,             "arp_accept" },
> >         { NET_IPV4_CONF_ARP_NOTIFY,             "arp_notify" },
> > +       { NET_IPV4_CONF_SRC_VMARK,              "src_valid_mark" },
> >         {}
> >  };
> > ---
> > 
> > Note we dont have that code anymore in current tree - thats why it
> > was missed...
> > If this works, Greg/Dave - please include it in the -stable patch.
> 
> I see, thanks for figuring this out Jamal.
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Thanks Jamal for the patch, I've now queued it up.

greg k-h
