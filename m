Return-Path: <linux-kernel-owner+w=401wt.eu-S932514AbZJLPCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514AbZJLPCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932504AbZJLPCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:02:15 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:35656 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932193AbZJLPCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:02:14 -0400
Date: Mon, 12 Oct 2009 10:54:41 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Mel Gorman <mel@csn.ul.ie>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V6 3/7] Use this_cpu operations in slub
In-Reply-To: <4AD302A8.4010409@kernel.org>
Message-ID: <alpine.DEB.1.10.0910121053240.7932@gentwo.org>
References: <20091007211024.442168959@gentwo.org> <20091007211052.614790286@gentwo.org> <4AD302A8.4010409@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009, Tejun Heo wrote:

> > -		c = get_cpu_slab(s, smp_processor_id());
> > +		c = __this_cpu_ptr(s->cpu_slab);
>
> Shouldn't this be this_cpu_ptr() without the double underscore?

Interrupts are disabled so no concurrent fast path can occur.


