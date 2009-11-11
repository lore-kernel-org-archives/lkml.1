Return-Path: <linux-kernel-owner+w=401wt.eu-S1755589AbZKKMqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589AbZKKMqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 07:46:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbZKKMqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 07:46:16 -0500
Received: from [95.166.99.235] ([95.166.99.235]:34540 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbZKKMqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 07:46:12 -0500
Date: Wed, 11 Nov 2009 13:46:17 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block core: use round_jiffies on timer to reduce
	wakeups
Message-ID: <20091111124617.GN8742@kernel.dk>
References: <4AFA03BB.90405@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFA03BB.90405@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10 2009, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Use round_jiffies() variant to schedule the timer along with
> other timer wakeups on the same CPU.
> 
> Source file also needs to include jiffies.h since it uses
> functions or macros from it.

round_jiffies() rounds to the next second, that's way too far away for
an event that should trigger within msecs.

-- 
Jens Axboe

