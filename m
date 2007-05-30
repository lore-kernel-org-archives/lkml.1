Return-Path: <linux-kernel-owner+w=401wt.eu-S1755833AbXE3XB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833AbXE3XB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 19:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbXE3XBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 19:01:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56067
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751676AbXE3XBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 19:01:49 -0400
Date: Wed, 30 May 2007 16:02:02 -0700 (PDT)
Message-Id: <20070530.160202.48808347.davem@davemloft.net>
To: mpm@selenic.com
Cc: kaber@trash.net, shemminger@linux-foundation.org,
       akpm@linux-foundation.org, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 3/4] Make net watchdog timers 1 sec jiffy aligned
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070530223612.GR11115@waste.org>
References: <20070530221039.GJ11166@waste.org>
	<20070530.152939.21591222.davem@davemloft.net>
	<20070530223612.GR11115@waste.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Mackall <mpm@selenic.com>
Date: Wed, 30 May 2007 17:36:12 -0500

> On Wed, May 30, 2007 at 03:29:39PM -0700, David Miller wrote:
> > From: Matt Mackall <mpm@selenic.com>
> > Date: Wed, 30 May 2007 17:10:39 -0500
> > 
> > > Are you agreeing that "it seems wasteful to add per-packet overhead"?
> > > This patch is not doing that.
> > 
> > Yes, and I know that :-)
> 
> Is there a real reason for watchdog_timeo to be all over the map?

In theory it's a hardware implementation and link speed specific value,
in reality nearly everyone just copies values from other drivers.

