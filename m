Return-Path: <linux-kernel-owner+w=401wt.eu-S1753242AbZBRJqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbZBRJqt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 04:46:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbZBRJql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 04:46:41 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37151 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbZBRJqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 04:46:40 -0500
Subject: Re: [PATCH 1/3] generic-ipi: simplify the barriers
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: paulmck@linux.vnet.ibm.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <20090218002702.GA25256@linux.vnet.ibm.com>
References: <20090217215904.059250145@chello.nl>
	 <20090217220053.410275566@chello.nl>
	 <20090218002702.GA25256@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Wed, 18 Feb 2009 10:45:58 +0100
Message-Id: <1234950358.4637.0.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-17 at 16:27 -0800, Paul E. McKenney wrote:

> While I sympathize with pushing memory barriers down into the
> arch-specific functions, you -are- running this by the various
> arch maintainers so that they have an opportunity to adjust, right?

Nick's initial posting of this patch included linux-arch -- maybe I
should have added that too.

