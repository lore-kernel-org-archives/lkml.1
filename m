Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbXJBHw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbXJBHw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 03:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbXJBHwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 03:52:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57742
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751770AbXJBHwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 03:52:18 -0400
Date: Tue, 02 Oct 2007 00:52:17 -0700 (PDT)
Message-Id: <20071002.005217.133194599.davem@davemloft.net>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, abhishekrai@google.com,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] Fix blktrace setup 32-bit ioctl on 64-bit kernels
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071002073943.GC5236@kernel.dk>
References: <20071002073943.GC5236@kernel.dk>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>
Date: Tue, 2 Oct 2007 09:39:43 +0200

> Hi,
> 
> The layout of struct blk_user_trace_setup is a bit unfortunate, it gets
> padded differently on 32-bit and 64-bit archs. So right now it's not
> possible to trace 64-bit kernels with a 32-bit app. This patch fixes
> that up by adding a compat ioctl handler for BLKTRACESETUP.
> 
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

Acked-by: David S. Miller <davem@davemloft.net>
