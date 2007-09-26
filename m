Return-Path: <linux-kernel-owner+w=401wt.eu-S1763079AbXIZVKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763079AbXIZVKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 17:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756438AbXIZVKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 17:10:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56243
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1762592AbXIZVK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 17:10:29 -0400
Date: Wed, 26 Sep 2007 14:10:29 -0700 (PDT)
Message-Id: <20070926.141029.111922368.davem@davemloft.net>
To: willy@linux.intel.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] dmapool: Validate parameters to dma_pool_create
From: David Miller <davem@davemloft.net>
In-Reply-To: <11908332793750-git-send-email-willy@linux.intel.com>
References: <20070926185757.GM3899@parisc-linux.org>
	<11908332793750-git-send-email-willy@linux.intel.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Wilcox <willy@linux.intel.com>
Date: Wed, 26 Sep 2007 15:01:17 -0400

> Check that 'align' is a power of two, like the API specifies.
> Align 'size' to 'align' correctly -- the current code has an off-by-one.
> The ALIGN macro in kernel.h doesn't.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

Acked-by: David S. Miller <davem@davemloft.net>
