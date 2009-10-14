Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbZJNS1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbZJNS1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 14:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756164AbZJNS1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 14:27:50 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:56519 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753013AbZJNS1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 14:27:50 -0400
Date: Wed, 14 Oct 2009 14:19:40 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Mel Gorman <mel@csn.ul.ie>, David Rientjes <rientjes@google.com>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: Re: [this_cpu_xx V6 7/7] this_cpu: slub aggressive use of this_cpu
  operations in the hotpaths
In-Reply-To: <84144f020910140914u2c08655bjbd870019689ac947@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0910141418480.9708@gentwo.org>
References: <alpine.DEB.1.00.0910130231570.27262@chino.kir.corp.google.com>  <alpine.DEB.1.10.0910131541290.7246@gentwo.org>  <alpine.DEB.1.00.0910131305440.3529@chino.kir.corp.google.com>  <alpine.DEB.1.10.0910131625370.13756@gentwo.org> 
 <alpine.DEB.1.00.0910131550050.15347@chino.kir.corp.google.com>  <20091014133457.GB5027@csn.ul.ie>  <alpine.DEB.1.10.0910141003590.9944@gentwo.org>  <20091014154944.GD5027@csn.ul.ie> <4AD5F3F8.8080603@cs.helsinki.fi>  <alpine.DEB.1.10.0910141154320.26476@gentwo.org>
 <84144f020910140914u2c08655bjbd870019689ac947@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Oct 2009, Pekka Enberg wrote:

> Yeah, that should help but it's probably not something we can do for
> mainline. I'm not sure how we can fix SLUB to support large objects
> out-of-the-box as efficiently as SLAB does.

We could add a per cpu "queue" through a pointer array in kmem_cache_cpu.
Which is more SLQB than SLUB.

