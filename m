Return-Path: <linux-kernel-owner+w=401wt.eu-S1759884AbYBLFkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759884AbYBLFkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 00:40:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbYBLFkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 00:40:05 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48441
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752464AbYBLFkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 00:40:04 -0500
Date: Mon, 11 Feb 2008 21:40:36 -0800 (PST)
Message-Id: <20080211.214036.154985035.davem@davemloft.net>
To: fujita.tomonori@lab.ntt.co.jp
Cc: tomof@acm.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: more iommu sg merging fallout
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080207103801T.fujita.tomonori@lab.ntt.co.jp>
References: <20080207085333Q.fujita.tomonori@lab.ntt.co.jp>
	<20080206.160147.25411834.davem@davemloft.net>
	<20080207103801T.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 07 Feb 2008 10:38:01 +0900

> Great, thanks! SPARC IOMMUs use bitmap for the free area management
> like POWER IOMMUs so it could use lib/iommu-helper as POWER does.

Please look at Linus's current tree, I believe I have things
in a working state, and the DMA mask portions should be easier
to add now.
