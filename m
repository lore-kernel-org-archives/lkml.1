Return-Path: <linux-kernel-owner+w=401wt.eu-S1758239AbYCYQYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239AbYCYQYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 12:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756831AbYCYQYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 12:24:07 -0400
Received: from relay1.sgi.com ([192.48.171.29]:49402 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756796AbYCYQYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 12:24:06 -0400
Date: Tue, 25 Mar 2008 11:24:04 -0500 (CDT)
From: Alan Mayer <ajm@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Mayer <ajm@sgi.com>, torvalds@linux-foundation.org,
       linux-kernel list <linux-kernel@vger.kernel.org>,
       Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH] x86_64: resize NR_IRQS for large machines
In-Reply-To: <20080325161901.GF27174@elte.hu>
Message-ID: <Pine.SGI.3.96.1080325112342.7873204V-100000@fergus.americas.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2008, Ingo Molnar wrote:

> 
> * Alan Mayer <ajm@sgi.com> wrote:
> 
> > Subject: [PATCH] x86_64: resize NR_IRQS for large machines
> > 
> > From: Alan Mayer <ajm@sgi.com>
> > 
> > On machines with very large numbers of cpus, tables that are 
> > dimensioned by NR_IRQS get very large, especially the irq_desc table.  
> > They are also very sparsely used.  When the cpu count is > 
> > MAX_IO_APICS, use MAX_IO_APICS to set NR_IRQS, otherwise use NR_CPUS.
> > 
> > Signed-off-by: Alan Mayer <ajm@sgi.com>
> > Reviewed-by: Christoph Lameter <clameter@sgi.com>
> 
> thanks, applied. I suspect this can wait until .26, as there appears to 
> be a number of other patches that you need to get these boxes running on 
> vanilla, right?
> 
> 	Ingo

That's right.  Thanks.

		--ajm

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

Spirits are using me,
A larger voice is calling me.
--
Alan J. Mayer
SGI
ajm@sgi.com
WORK: 651-683-3131
HOME: 651-407-0134
--

