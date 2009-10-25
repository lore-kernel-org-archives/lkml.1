Return-Path: <linux-kernel-owner+w=401wt.eu-S1752803AbZJYIB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbZJYIB1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 04:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbZJYIB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 04:01:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:58138 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbZJYIBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 04:01:25 -0400
Subject: Re: [PATCH 3/3] sched: Disable affine wakeups by default
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20091024130728.051c4d7c@infradead.org>
References: <20091024125853.35143117@infradead.org>
	 <20091024130432.0c46ef27@infradead.org>
	 <20091024130728.051c4d7c@infradead.org>
Content-Type: text/plain
Date: Sun, 25 Oct 2009 09:01:25 +0100
Message-Id: <1256457685.7356.3.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-10-24 at 13:07 -0700, Arjan van de Ven wrote:
> Subject: sched: Disable affine wakeups by default
> From: Arjan van de Ven <arjan@linux.intel.com>
> 
> The global affine wakeup scheduler feature sounds nice, but there is a problem
> with this: This is ALSO a per scheduler domain feature already.
> By having the global scheduler feature enabled by default, the scheduler domains
> no longer have the option to opt out.
> 
> There are domains (for example the HT/SMT domain) that have good reason to want
> to opt out of this feature.
> 
> With this patch they can opt out, while all other domains currently default to
> the affine setting anyway.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> 

Hell no, that'll destroy many workloads. What you could possibly do is
disable it for sched domains that are known to share cache, maybe.

