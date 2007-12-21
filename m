Return-Path: <linux-kernel-owner+w=401wt.eu-S1765307AbXLUAkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765307AbXLUAkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 19:40:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758498AbXLUAkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 19:40:04 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59751
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755963AbXLUAkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 19:40:01 -0500
Date: Thu, 20 Dec 2007 16:40:00 -0800 (PST)
Message-Id: <20071220.164000.210277365.davem@davemloft.net>
To: rusty@rustcorp.com.au
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [PATCH 2/5] dma_map_sg_ring() helper
From: David Miller <davem@davemloft.net>
In-Reply-To: <200712211135.13150.rusty@rustcorp.com.au>
References: <200712210958.56994.rusty@rustcorp.com.au>
	<20071221090027K.fujita.tomonori@lab.ntt.co.jp>
	<200712211135.13150.rusty@rustcorp.com.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 21 Dec 2007 11:35:12 +1100

> On Friday 21 December 2007 11:00:27 FUJITA Tomonori wrote:
> > We need to pass the whole sg entries to the IOMMUs at a time.
> 
> Hi Fujita,
> 
>     OK, it's certainly possible to have an arch override.  For which 
> architecture is this BTW?

SPARC64, POWERPC, maybe IA-64 etc.

Basically any platform that potentially does virtual
remamping and thus linearization.

I think it should always be provided, the new APIs give
less information to the implementation and that's a step
backwards.
