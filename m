Return-Path: <linux-kernel-owner+w=401wt.eu-S965983AbXCFS21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965983AbXCFS21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:28:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965986AbXCFS20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:28:26 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:39057 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965983AbXCFS2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:28:23 -0500
Date: Fri, 2 Mar 2007 10:08:04 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@muc.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       netdev@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC] Arp announce (for Xen)
Message-ID: <20070302180804.GH10574@sequoia.sous-sol.org>
References: <20070301232443.195603797@goop.org> <20070301232529.648076372@goop.org> <20070301164214.4a40bc59@freekitty> <45E7764A.7000100@goop.org> <20070301173030.754514ec@freekitty>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070301173030.754514ec@freekitty>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Hemminger (shemminger@linux-foundation.org) wrote:
> +	case NETDEV_CHANGEADDR:
> +		/* Send gratuitous ARP in case of address change or new device */
> +		if (IN_DEV_ARP_ANNOUNCE(in_dev))

Conceptually right on, but it looks like improper hijacking
of arp_announce sysctl.  Could introduce another

thanks,
-chris
