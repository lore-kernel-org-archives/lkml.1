Return-Path: <linux-kernel-owner+w=401wt.eu-S1764316AbZEHXaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764316AbZEHXaQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 19:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756889AbZEHX34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 19:29:56 -0400
Received: from mail.vyatta.com ([76.74.103.46]:45057 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754468AbZEHX3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 19:29:55 -0400
Date: Fri, 8 May 2009 16:29:49 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: David Miller <davem@davemloft.net>
Cc: jpirko@redhat.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jgarzik@pobox.com, shemminger@linux-foundation.org,
       bridge@lists.linux-foundation.org, fubar@us.ibm.com,
       bonding-devel@lists.sourceforge.net, kaber@trash.net,
       mschmidt@redhat.com, dada1@cosmosbay.com, ivecera@redhat.com
Subject: Re: [PATCH] net: introduce a list of device addresses dev_addr_list
 (v6)
Message-ID: <20090508162949.4e76abd6@nehalam>
In-Reply-To: <20090508.162555.193731410.davem@davemloft.net>
References: <20090508153842.65ce3bed@s6510>
	<20090508.160008.127530143.davem@davemloft.net>
	<20090508161204.134668b9@nehalam>
	<20090508.162555.193731410.davem@davemloft.net>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 May 2009 16:25:55 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Stephen Hemminger <shemminger@vyatta.com>
> Date: Fri, 8 May 2009 16:12:04 -0700
> 
> > But the other infrastructure may have same issues (netfilter, etc).
> > Just seems like it would be either to have multiple network devices
> > so that upper layers could disambiguate easier.
> 
> That's quite a heavyweight solution to what is purely
> an addressing issue, don't you think?
> 
> We can just revert all of that netdev_ops stuff if you
> think per-netdev cost doesn't matter :-)

I am just concerned that is a fundamental change (like MQ) was and
it will take a couple of releases to shake out all the inter-relationships.
When an architectural change is made, would like to see more analysis done.
Netdev-ops was more of a refactoring than a change to what protocols
and qdisc/filters/... see.

-- 
