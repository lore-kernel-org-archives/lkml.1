Return-Path: <linux-kernel-owner+w=401wt.eu-S1763607AbZEHX0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763607AbZEHX0Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 19:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754394AbZEHX0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 19:26:01 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52618
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754468AbZEHX0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 19:26:00 -0400
Date: Fri, 08 May 2009 16:25:55 -0700 (PDT)
Message-Id: <20090508.162555.193731410.davem@davemloft.net>
To: shemminger@vyatta.com
Cc: jpirko@redhat.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jgarzik@pobox.com, shemminger@linux-foundation.org,
       bridge@lists.linux-foundation.org, fubar@us.ibm.com,
       bonding-devel@lists.sourceforge.net, kaber@trash.net,
       mschmidt@redhat.com, dada1@cosmosbay.com, ivecera@redhat.com
Subject: Re: [PATCH] net: introduce a list of device addresses
 dev_addr_list (v6)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090508161204.134668b9@nehalam>
References: <20090508153842.65ce3bed@s6510>
	<20090508.160008.127530143.davem@davemloft.net>
	<20090508161204.134668b9@nehalam>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Fri, 8 May 2009 16:12:04 -0700

> But the other infrastructure may have same issues (netfilter, etc).
> Just seems like it would be either to have multiple network devices
> so that upper layers could disambiguate easier.

That's quite a heavyweight solution to what is purely
an addressing issue, don't you think?

We can just revert all of that netdev_ops stuff if you
think per-netdev cost doesn't matter :-)
