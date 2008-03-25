Return-Path: <linux-kernel-owner+w=401wt.eu-S1757924AbYCYQT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924AbYCYQT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 12:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756245AbYCYQTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 12:19:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53120 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756077AbYCYQTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 12:19:20 -0400
Date: Tue, 25 Mar 2008 17:19:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Mayer <ajm@sgi.com>
Cc: torvalds@linux-foundation.org,
       linux-kernel list <linux-kernel@vger.kernel.org>,
       Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH] x86_64: resize NR_IRQS for large machines
Message-ID: <20080325161901.GF27174@elte.hu>
References: <Pine.SGI.3.96.1080324092858.7873204S-100000@fergus.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.SGI.3.96.1080324092858.7873204S-100000@fergus.americas.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Alan Mayer <ajm@sgi.com> wrote:

> Subject: [PATCH] x86_64: resize NR_IRQS for large machines
> 
> From: Alan Mayer <ajm@sgi.com>
> 
> On machines with very large numbers of cpus, tables that are 
> dimensioned by NR_IRQS get very large, especially the irq_desc table.  
> They are also very sparsely used.  When the cpu count is > 
> MAX_IO_APICS, use MAX_IO_APICS to set NR_IRQS, otherwise use NR_CPUS.
> 
> Signed-off-by: Alan Mayer <ajm@sgi.com>
> Reviewed-by: Christoph Lameter <clameter@sgi.com>

thanks, applied. I suspect this can wait until .26, as there appears to 
be a number of other patches that you need to get these boxes running on 
vanilla, right?

	Ingo
