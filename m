Return-Path: <linux-kernel-owner+w=401wt.eu-S1762947AbYFZNJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762947AbYFZNJ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762179AbYFZMy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:54:29 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57239 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762182AbYFZMy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:54:28 -0400
Message-ID: <48639180.2090005@firstfloor.org>
Date: Thu, 26 Jun 2008 14:54:24 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, stern@rowland.harvard.edu,
       linux-kernel@vger.kernel.org, antonio.lin@alcormicro.com,
       david.vrabel@csr.com
Subject: Re: Scatter-gather list constraints
References: <20080626110615U.fujita.tomonori@lab.ntt.co.jp> <20080626143928P.fujita.tomonori@lab.ntt.co.jp> <20080626063559.GJ20851@kernel.dk> <20080626155834I.fujita.tomonori@lab.ntt.co.jp> <20080626123936.GV20851@kernel.dk>
In-Reply-To: <20080626123936.GV20851@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On the fs side, just setting a hw block size of 1k should fix the
> problem, since that'd be your minimum transfer size AND alignment there
> even for O_DIRECT IO.

XFS used to force 512 byte IOs for its log IO. Not sure
that was ever fixed. If it was fixed it likely required a disk format
change (I think s390 ran into a problem like this)

-Andi

