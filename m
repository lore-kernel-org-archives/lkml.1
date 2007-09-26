Return-Path: <linux-kernel-owner+w=401wt.eu-S1762598AbXIZVNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762598AbXIZVNd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 17:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758062AbXIZVNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 17:13:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56246
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753459AbXIZVNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 17:13:24 -0400
Date: Wed, 26 Sep 2007 14:13:24 -0700 (PDT)
Message-Id: <20070926.141324.83603136.davem@davemloft.net>
To: willy@linux.intel.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] Change dmapool free block management
From: David Miller <davem@davemloft.net>
In-Reply-To: <1190833279354-git-send-email-willy@linux.intel.com>
References: <20070926185757.GM3899@parisc-linux.org>
	<1190833279354-git-send-email-willy@linux.intel.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Wilcox <willy@linux.intel.com>
Date: Wed, 26 Sep 2007 15:01:18 -0400

> Also add documentation for how dma pools work, move the header above the
> includes, add my copyright, add the original author's copyright, add a
> GPL v2 licence to the file and fix the includes.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

Correct or not, you need to describe how you are changing the
free block management, why that transformation is valid and
worthwhile, etc.

I can see that you're getting rid of a bitmap and replacing it
with the dma_page->in_use et al. stuff, but you need to describe
that in detail.
