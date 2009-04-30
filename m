Return-Path: <linux-kernel-owner+w=401wt.eu-S1763920AbZD3Op2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763920AbZD3Op2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 10:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763114AbZD3OpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 10:45:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35746 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762816AbZD3OpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 10:45:06 -0400
Date: Thu, 30 Apr 2009 16:44:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nikanth Karthikesan <knikanth@novell.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Detect and warn on atomic_inc/atomic_dec wrapping
	around
Message-ID: <20090430144449.GD14897@elte.hu>
References: <200904291221.40361.knikanth@novell.com> <200904301921.44615.knikanth@novell.com> <20090430140559.GA14696@elte.hu> <200904301939.51022.knikanth@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904301939.51022.knikanth@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nikanth Karthikesan <knikanth@novell.com> wrote:

> > and here:
> >
> > 		KERN_ERR "atomic inc underflow!");
> >
> > other than these two small details this is looking really nice now.
> >
> 
> Done.

Thanks. Looks unconditionally good now.

Andrew, this looks like it fits -mm's profile best - can you see any 
other problems in the patch? (Perhaps CONFIG_VM_DEBUG should 
auto-select this option?)

	Ingo
