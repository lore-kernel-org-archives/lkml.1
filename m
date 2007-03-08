Return-Path: <linux-kernel-owner+w=401wt.eu-S2992793AbXCHAHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992793AbXCHAHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 19:07:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992792AbXCHAHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 19:07:43 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37285
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S2992789AbXCHAHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 19:07:42 -0500
Date: Wed, 07 Mar 2007 16:07:40 -0800 (PST)
Message-Id: <20070307.160740.77057241.davem@davemloft.net>
To: eparis@parisplace.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jmorris@namei.org,
       vyekkirala@trustedcs.com, cxzhang@watson.ibm.com, sds@tycho.nsa.gov
Subject: Re: [PATCH] Add xfrm policy change auditing to pfkey_spdget
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070307.154316.68038380.davem@davemloft.net>
References: <1172861484.31047.26.camel@localhost.localdomain>
	<20070307.154316.68038380.davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Wed, 07 Mar 2007 15:43:16 -0800 (PST)

> From: Eric Paris <eparis@parisplace.org>
> Date: Fri, 02 Mar 2007 13:51:24 -0500
> 
> > pfkey_spdget neither had an LSM security hook nor auditing for the
> > removal of xfrm_policy structs.  The security hook was added when it was
> > moved into xfrm_policy_byid instead of the callers to that function by
> > my earlier patch and this patch adds the auditing hooks as well.
> > 
> > Signed-off-by: Eric Paris <eparis@redhat.com>
> 
> Applied.

This patch was missing an openning brace on the "if (delete)" line.
Eric you don't post patches without at least compile testing
them now do you? :-)

I fixed this up, but I will just kick it back to you next time,
and I will likely growl very loudly in your general direction
too. ;)
