Return-Path: <linux-kernel-owner+w=401wt.eu-S1756431AbZLPR43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431AbZLPR43 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 12:56:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753386AbZLPR42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 12:56:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:45709 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbZLPR41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 12:56:27 -0500
Subject: Re: [PATCH 02/12] sched: Fix set_cpu_active() in cpu_down()
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Xiaotian Feng <dfeng@redhat.com>
In-Reply-To: <20091216170517.500272612@chello.nl>
References: <20091216170430.073353839@chello.nl>
	 <20091216170517.500272612@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Dec 2009 18:56:19 +0100
Message-ID: <1260986179.21028.151.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-16 at 18:04 +0100, Peter Zijlstra wrote:
> plain text document attachment (foo13.patch)

still need to fix quilt...

From: Xiaotian Feng <dfeng@redhat.com>

> Sachin found cpu hotplug test failures on powerpc, which made the
> kernel hang on his POWER box. 
> 
> The problem is that we fail to re-activate a cpu when a hot-unplug
> fails. Fix this by moving the de-activation into _cpu_down after doing
> the initial checks.
> 
> Remove the synchronize_sched() calls and rely on those implied by
> rebuilding the sched domains using the new mask.
> 
> Reported-by: Sachin Sant <sachinp@in.ibm.com>
> Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
> Tested-by: Sachin Sant <sachinp@in.ibm.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

