Return-Path: <linux-kernel-owner+w=401wt.eu-S1760335AbZJMPk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760335AbZJMPk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 11:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760319AbZJMPkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 11:40:55 -0400
Received: from gir.skynet.ie ([193.1.99.77]:41897 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759495AbZJMPkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 11:40:53 -0400
Date: Tue, 13 Oct 2009 16:40:20 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: cl@linux-foundation.org
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V6 0/7] Introduce per cpu atomic operations and
	avoid per cpu address arithmetic
Message-ID: <20091013154020.GA18716@csn.ul.ie>
References: <20091007211024.442168959@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20091007211024.442168959@gentwo.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 05:10:24PM -0400, cl@linux-foundation.org wrote:
> V5->V6:
> - Drop patches merged by Tejun.
> - Drop irqless slub fastpath for now.
> - Patches against Tejun percpu for-next branch.
> 

FWIW, this fails to boot on latest mmotm on x86-64 even though the patches
apply. It fails to create basic slab cackes like kmalloc-64.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
