Return-Path: <linux-kernel-owner+w=401wt.eu-S1754655Ab0AEWhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab0AEWhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 17:37:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754357Ab0AEWhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 17:37:06 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:37395 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab0AEWhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 17:37:05 -0500
Date: Tue, 5 Jan 2010 16:35:56 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [this_cpu_xx V8 11/16] Generic support for this_cpu_cmpxchg
In-Reply-To: <20100105222905.GA30726@Krystal>
Message-ID: <alpine.DEB.2.00.1001051635040.9108@router.home>
References: <20091218222617.384355422@quilx.com> <20091218222653.560936448@quilx.com> <20091219144520.GA9134@Krystal> <alpine.DEB.2.00.0912220950030.12163@router.home> <20091222172436.GB12529@Krystal> <alpine.DEB.2.00.1001041116010.7191@router.home>
 <20100105222905.GA30726@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jan 2010, Mathieu Desnoyers wrote:

> This scheme where Steven moves buffers from one CPU to another, he only
> performs this operation when some other exclusion mechanism ensures that
> the buffer is not used for writing by the CPU when this move operation
> is done.
>
> It is therefore correct, and needs local_t type to deal with the data
> structure hierarchy vs atomic exchange as I pointed in my email.

Yes this_cpu_xx does not seem to work for your scheme. Please review the
patchset that I sent you instead.

