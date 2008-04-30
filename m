Return-Path: <linux-kernel-owner+w=401wt.eu-S1759502AbYD3HZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759502AbYD3HZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 03:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755048AbYD3HZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 03:25:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42247
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755007AbYD3HZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 03:25:31 -0400
Date: Wed, 30 Apr 2008 00:25:30 -0700 (PDT)
Message-Id: <20080430.002530.189687792.davem@davemloft.net>
To: kamezawa.hiroyu@jp.fujitsu.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       y-goto@jp.fujitsu.com
Subject: Re: sparc64 bootup regression...
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080430161540.bfff2c45.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080429.231241.221824292.davem@davemloft.net>
	<20080429233832.168fb6ee.akpm@linux-foundation.org>
	<20080430161540.bfff2c45.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 30 Apr 2008 16:15:40 +0900

> How about this ? If this is messy (or doesn't work), Goto-san will rework
> his own patch by himself. (this patch is against -mm but I think no HUNK to
> git tree)

This makes the original change pointless.

If the goal is to put the usemap in the same section as the memory
itself, in order to allow for it to be freed during memory hotplug,
this new change just makes the facility not work some of the time.

Now maybe sometimes it will work, maybe sometimes it will not.

It's not the end of the world if this change is reverted for a few
days while we work out what to do about this.

Really, it does not reflect badly upon you or Goto-san, if the change
is reverted temporarily.
