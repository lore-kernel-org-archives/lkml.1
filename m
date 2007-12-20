Return-Path: <linux-kernel-owner+w=401wt.eu-S1758896AbXLTH6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758896AbXLTH6Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 02:58:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754536AbXLTH6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 02:58:15 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49956
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750746AbXLTH6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 02:58:14 -0500
Date: Wed, 19 Dec 2007 23:58:07 -0800 (PST)
Message-Id: <20071219.235807.173273479.davem@davemloft.net>
To: rusty@rustcorp.com.au
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com, dougg@torque.net
Subject: Re: [PATCH 0/5] sg_ring for scsi
From: David Miller <davem@davemloft.net>
In-Reply-To: <200712201853.48643.rusty@rustcorp.com.au>
References: <200712201645.19035.rusty@rustcorp.com.au>
	<20071220160741K.fujita.tomonori@lab.ntt.co.jp>
	<200712201853.48643.rusty@rustcorp.com.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 20 Dec 2007 18:53:48 +1100

> Manipulating the magic chains is horrible; it looks simple to the
> places which simply want to iterate through it, but it's awful for
> code which wants to create them.

I'm not saying complexity is inherent in this stuff, but
assuming that it is the complexity should live as far away
from the minions (the iterators in this case).  Therefore,
the creators is the right spot for the hard stuff.
