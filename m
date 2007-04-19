Return-Path: <linux-kernel-owner+w=401wt.eu-S1767011AbXDSUKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767011AbXDSUKM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 16:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767014AbXDSUKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 16:10:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46165
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1767011AbXDSUKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 16:10:11 -0400
Date: Thu, 19 Apr 2007 13:10:14 -0700 (PDT)
Message-Id: <20070419.131014.31605466.davem@davemloft.net>
To: ak@suse.de
Cc: discuss@x86-64.org, linux-kernel@vger.kernel.org, arjan@linux.intel.com
Subject: Re: Dropping CONFIG_REORDER on x86-64 for 2.6.22
From: David Miller <davem@davemloft.net>
In-Reply-To: <200704191354.52985.ak@suse.de>
References: <200704191354.52985.ak@suse.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@suse.de>
Date: Thu, 19 Apr 2007 13:54:52 +0200

> So I'm planning to drop the option and arch/x86_64/kernel/functionlist

Please do so, I'm tired of editing that file every time I remove
something from the tree.

That file had alloc_skb_from_cache() in it, which nothing in the
vanilla kernel ever invoked.  How did it even get there?  If it was
put there for Xen's sake, that stinks because Xen is out of tree.
