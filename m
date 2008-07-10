Return-Path: <linux-kernel-owner+w=401wt.eu-S1757443AbYGJCfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbYGJCfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 22:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbYGJCfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 22:35:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbYGJCfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 22:35:31 -0400
Date: Wed, 9 Jul 2008 22:34:29 -0400
From: Bill Nottingham <notting@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: kaber@trash.net, bridge@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] Allow full bridge configuration via sysfs
Message-ID: <20080710023429.GB24665@nostromo.devel.redhat.com>
Mail-Followup-To: David Miller <davem@davemloft.net>, kaber@trash.net,
	bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
References: <20080707205342.GA19710@nostromo.devel.redhat.com> <4872838B.1060603@trash.net> <20080707213420.GA20089@nostromo.devel.redhat.com> <20080707.145259.103902820.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080707.145259.103902820.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller (davem@davemloft.net) said: 
> > Why, if netlink is the standard (and it's been around for a long
> > damn time), was sysfs configuration for bonding added in 2005? Why
> > was bridge configuration added in 2005, and *extended* in 2006 and
> > 2007? Why were the user-space tools such as brctl ported from ioctl
> > to sysfs?
> 
> Because often a lot of shit slips in when someone who understands
> the ramifications is too busy or on vacation.

Duly noted, will time all patch submissions to land during your
vacations in the future.

More seriously, if there's not a mechanism to prevent ABIs the
kernel doesn't want like this being added, that's a problem.

> We do want everything to be netlink based.
> 
> Why?
> 
> Because it means that you can run one monitoring tool to listen
> for netlink events and report them to the user for diagnosis.
> 
> It means that network configuration events can be sent over
> the wire and used remotely at some point.
> 
> The latter can never happen as long as we keep adding ad-hoc
> config stuff.

Sure, but it does make them more opaque to the normal user,
leaving them wrapped in the same old ip/brctl/ifenslave/vconfig
tools - for better or worse, people like the discoverability
and obviousness of sysfs.

Bill
