Return-Path: <linux-kernel-owner+w=401wt.eu-S1761483AbXIZVKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761483AbXIZVKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 17:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756438AbXIZVKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 17:10:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56240
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754650AbXIZVKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 17:10:08 -0400
Date: Wed, 26 Sep 2007 14:10:08 -0700 (PDT)
Message-Id: <20070926.141008.25425420.davem@davemloft.net>
To: willy@linux.intel.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Avoid taking waitqueue lock in dmapool
From: David Miller <davem@davemloft.net>
In-Reply-To: <11908332791719-git-send-email-willy@linux.intel.com>
References: <20070926185757.GM3899@parisc-linux.org>
	<11908332791719-git-send-email-willy@linux.intel.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Wilcox <willy@linux.intel.com>
Date: Wed, 26 Sep 2007 15:01:16 -0400

> With one trivial change (taking the lock slightly earlier on wakeup
> from schedule), all uses of the waitq are under the pool lock, so we
> can use the locked (or __) versions of the wait queue functions, and
> avoid the extra spinlock.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

This one looks good to me:

Acked-by: David S. Miller <davem@davemloft.net>
