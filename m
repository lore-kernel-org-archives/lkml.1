Return-Path: <linux-kernel-owner+w=401wt.eu-S934257AbXHJWqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934257AbXHJWqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 18:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754577AbXHJWqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 18:46:01 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55905
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753415AbXHJWqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 18:46:00 -0400
Date: Fri, 10 Aug 2007 15:46:01 -0700 (PDT)
Message-Id: <20070810.154601.98709831.davem@davemloft.net>
To: greearb@candelatech.com
Cc: jeff@garzik.org, auke-jan.h.kok@intel.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Add ETHTOOL_[GS]FLAGS sub-ioctls
From: David Miller <davem@davemloft.net>
In-Reply-To: <46BCE942.1030107@candelatech.com>
References: <46BCD47C.9060408@candelatech.com>
	<20070810.151039.31642625.davem@davemloft.net>
	<46BCE942.1030107@candelatech.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Greear <greearb@candelatech.com>
Date: Fri, 10 Aug 2007 15:40:02 -0700

> For GSO on output, is there a generic fallback for any driver that
> does not specifically implement GSO?

Absolutely, in fact that's mainly what it's there for.

I don't think there is any issue.  The knob is there via
ethtool for people who really want to disable it.
