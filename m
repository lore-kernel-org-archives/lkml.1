Return-Path: <linux-kernel-owner+w=401wt.eu-S1767339AbXDEVfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767339AbXDEVfa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 17:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767337AbXDEVf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 17:35:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50550
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1767339AbXDEVf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 17:35:28 -0400
Date: Thu, 05 Apr 2007 14:35:27 -0700 (PDT)
Message-Id: <20070405.143527.63129672.davem@davemloft.net>
To: peter.p.waskiewicz.jr@intel.com
Cc: jeb.j.cramer@intel.com, christopher.leech@intel.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       auke-jan.h.kok@intel.com
Subject: Re: [PATCH] NET: Multiqueue network device support, replayed.
From: David Miller <davem@davemloft.net>
In-Reply-To: <D5C1322C3E673F459512FB59E0DDC329029ADBC2@orsmsx414.amr.corp.intel.com>
References: <D5C1322C3E673F459512FB59E0DDC329029ADBC2@orsmsx414.amr.corp.intel.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
Date: Thu, 5 Apr 2007 14:33:19 -0700

> David,
> 	Please consider pulling from my git tree:
> 
> 	git-pull git://lost.foo-projects.org/~ppwaskie/git/net-2.6.22
> multiqueue
> 
> This is a branch named 'multiqueue' of a recent pull from your tree with
> an updated implementation of the multiqueue implementation we've been
> working on.  Included in this is:
> 
> 1) A simplified API where all drivers will allocate a queue struct for
> each queue on the NIC.
> 2) A transparent stack change for both non-mq and mq devices to use the
> same codepath.
> 3) Remove the per-queue locking model, and just use the per-queue
> netif_{start|stop|wake}_subqueue() functions for multiqueue management.
> 4) Updated multiqueue documentation in Documentation/networking
> describing the implementation and base driver requirements to implement
> multiqueue support.

Thanks for following up on this work, but it really needs to be
reviewed here on netdev, I really can't just pull this into my
tree until it is reviewed properly here.

So, please post the new feature as a set of patches.

Thanks a lot.
