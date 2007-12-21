Return-Path: <linux-kernel-owner+w=401wt.eu-S1763940AbXLUAbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763940AbXLUAbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 19:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755274AbXLUAbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 19:31:00 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42611
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755232AbXLUAa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 19:30:59 -0500
Date: Thu, 20 Dec 2007 16:30:58 -0800 (PST)
Message-Id: <20071220.163058.185565456.davem@davemloft.net>
To: rusty@rustcorp.com.au
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com, dougg@torque.net
Subject: Re: [PATCH 0/5] sg_ring for scsi
From: David Miller <davem@davemloft.net>
In-Reply-To: <200712211013.38511.rusty@rustcorp.com.au>
References: <200712201853.48643.rusty@rustcorp.com.au>
	<20071219.235807.173273479.davem@davemloft.net>
	<200712211013.38511.rusty@rustcorp.com.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 21 Dec 2007 10:13:38 +1100

> But, as demonstrated, there are real benefits of having an explicit header:
> 
> 1) It removes the chain-end/explicit count ambiguity (see 
> http://lkml.org/lkml/2007/10/25/209 & thread)
> 2) It allows others to manipulate sg chains, which couldn't be done before
>    (eg. the ATA code which wants to append a padding element).
> 3) I can now hand you an sg ring for you to fill: sg chains can't do that.
> 
> In short, sg_ring is generally useful primitive.  sg chains are a clever hack 
> for scsi_lib to create, and everyone else to read.

I do not refute any of this :-)
