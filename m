Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbYAXQHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbYAXQHf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 11:07:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbYAXQHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:07:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56676 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752876AbYAXQHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:07:21 -0500
Date: Thu, 24 Jan 2008 17:07:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make idle iopriority class safe for non-root
Message-ID: <20080124160703.GE4857@elte.hu>
References: <20080123101142.GJ6258@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080123101142.GJ6258@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0536]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jens Axboe <jens.axboe@oracle.com> wrote:

> Hi,
> 
> Currently you must be root to set idle io prio class on a process. 
> This is due to the fact that the idle class is implemented as a true 
> idle class, meaning that it will not make progress if someone else is 
> requesting disk access. Unfortunately this means that it opens DOS 
> opportunities by locking down file system resources, hence it is root 
> only at the moment.
> 
> This patch relaxes the idle class a little, by removing the truly idle 
> part (which entals a grace period with associated timer). The 
> modifications make the idle class as close to zero impact as can be 
> done while still guarenteeing progress. This means we can relax the 
> root only criteria as well.

nice stuff!

	Ingo
