Return-Path: <linux-kernel-owner+w=401wt.eu-S1764008AbXF1Phm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764008AbXF1Phm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 11:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758699AbXF1PhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 11:37:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757042AbXF1PhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 11:37:15 -0400
Date: Thu, 28 Jun 2007 16:34:08 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH 2.6.22-rc6-mm1] compile error when CONFIG_DM_NETLINK is not defined
Message-ID: <20070628153407.GX25016@agk.fab.redhat.com>
Mail-Followup-To: Alasdair G Kergon <agk@redhat.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Mike Anderson <andmike@us.ibm.com>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org> <1183042157.9880.9.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183042157.9880.9.camel@kleikamp.austin.ibm.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2007 at 09:49:17AM -0500, Dave Kleikamp wrote:
> I got this compile error:
>   LD      drivers/md/built-in.o
> drivers/md/dm-multipath.o: In function `dm_path_event':
> drivers/md/dm-netlink.h:56: multiple definition of `dm_path_event'
> drivers/md/dm-mod.o:drivers/md/dm-netlink.h:56: first defined here
> drivers/md/dm-multipath.o: In function `dm_netlink_send_events':
> drivers/md/dm-netlink.h:51: multiple definition of `dm_netlink_send_events'
> drivers/md/dm-mod.o:drivers/md/dm-netlink.h:51: first defined here
> make[2]: *** [drivers/md/built-in.o] Error 1
> 
> I was able to fix it by making the dummy inline functions static.
> 
> Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

Sorry for that - I've added your fix to dm-netlink-add-to-core.patch.
Of course I forgot to test with the new option disabled:-(

Alasdair
-- 
agk@redhat.com
