Return-Path: <linux-kernel-owner+w=401wt.eu-S1756368AbXJDEnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368AbXJDEnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 00:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751047AbXJDEnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 00:43:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47613
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750744AbXJDEnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 00:43:08 -0400
Date: Wed, 03 Oct 2007 21:43:06 -0700 (PDT)
Message-Id: <20071003.214306.41634525.davem@davemloft.net>
To: arjan@infradead.org
Cc: clameter@sgi.com, akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, ak@suse.de, travis@sgi.com
Subject: Re: [14/18] Configure stack size
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071003213631.7a047dde@laptopd505.fenrus.org>
References: <20071004035935.042951211@sgi.com>
	<20071004040004.936534357@sgi.com>
	<20071003213631.7a047dde@laptopd505.fenrus.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@infradead.org>
Date: Wed, 3 Oct 2007 21:36:31 -0700

> there is still code that does DMA from and to the stack....
> how would this work with virtual allocated stack?

That's a bug and must be fixed.

There honestly shouldn't be that many examples around.

FWIW, there are platforms using a virtually allocated kernel stack
already.
