Return-Path: <linux-kernel-owner+w=401wt.eu-S1753298AbXJWQbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbXJWQbQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 12:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbXJWQas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 12:30:48 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50106 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721AbXJWQar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 12:30:47 -0400
Date: Tue, 23 Oct 2007 22:13:07 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Paul Menage <menage@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] CFS CGroup: Report usage
Message-ID: <20071023164307.GD4667@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <471D4523.4040509@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471D4523.4040509@google.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 05:49:39PM -0700, Paul Menage wrote:
> +	for_each_possible_cpu(i) {
> +		unsigned long flags;
> +		spin_lock_irqsave(&tg->cfs_rq[i]->rq->lock, flags);

A simpler form of this would be just:

		spin_lock_irqsave(&cpu_rq(i)->lock, flags);

-- 
Regards,
vatsa
