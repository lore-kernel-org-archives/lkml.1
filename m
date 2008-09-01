Return-Path: <linux-kernel-owner+w=401wt.eu-S1752415AbYIAGxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415AbYIAGxh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 02:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbYIAGx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 02:53:29 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:33164 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbYIAGx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 02:53:28 -0400
Date: Mon, 1 Sep 2008 08:53:24 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: Greg KH <greg@kroah.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] block: restore original behavior of /proc/partition when  there's no partition
Message-ID: <20080901065323.GB20055@kernel.dk>
References: <48B95307.8040902@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B95307.8040902@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30 2008, Tejun Heo wrote:
> /proc/partitions didn't use to write out the header if there was no
> partition.  However, recent commit 66c64afe changed the behavior.
> This is nothing major but there's no reason to change user visible
> behavior without a good rationale.  Restore the original behavior.
> 
> Note that 2.6.28 has clean up changes scheduled which will replace
> this rather hacky implementation.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Greg KH <greg@kroah.com>
> Cc: Kay Sievers <kay.sievers@vrfy.org>

I agree, queued up.

-- 
Jens Axboe

