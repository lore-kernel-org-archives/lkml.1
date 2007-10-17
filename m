Return-Path: <linux-kernel-owner+w=401wt.eu-S1760579AbXJQImT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760579AbXJQImT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 04:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756488AbXJQImE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 04:42:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41821
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755338AbXJQImB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 04:42:01 -0400
Date: Wed, 17 Oct 2007 01:42:11 -0700 (PDT)
Message-Id: <20071017.014211.41637735.davem@davemloft.net>
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH] SPARC64: fix iommu sg chaining
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071017.013325.74747630.davem@davemloft.net>
References: <20071017140747Q.fujita.tomonori@lab.ntt.co.jp>
	<20071017072149.GC5041@kernel.dk>
	<20071017.013325.74747630.davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Wed, 17 Oct 2007 01:33:25 -0700 (PDT)

> sg_next() gives you a NULL after the last entry, but tests have been
> changed to compare against sg_last() which is likely not what we
> want for those checks.

This of course isn't true, ignore me as I'm still learning how this
new stuff works :-)
