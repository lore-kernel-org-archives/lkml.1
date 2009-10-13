Return-Path: <linux-kernel-owner+w=401wt.eu-S1761254AbZJMUdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761254AbZJMUdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 16:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761244AbZJMUda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 16:33:30 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:33973 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761239AbZJMUd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 16:33:29 -0400
Date: Tue, 13 Oct 2009 16:25:18 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Mel Gorman <mel@csn.ul.ie>, Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: Re: [this_cpu_xx V6 7/7] this_cpu: slub aggressive use of this_cpu
 operations in the hotpaths
In-Reply-To: <4AD4D8B6.6010700@cs.helsinki.fi>
Message-ID: <alpine.DEB.1.10.0910131624330.13756@gentwo.org>
References: <20091007211024.442168959@gentwo.org> <20091007211053.378634196@gentwo.org> <4AD307A5.105@kernel.org> <84144f020910120614r529d8e4em9babe83a90e9371f@mail.gmail.com> <alpine.DEB.1.00.0910130231570.27262@chino.kir.corp.google.com>
 <alpine.DEB.1.10.0910131041450.21608@gentwo.org> <alpine.DEB.1.10.0910131509170.32394@gentwo.org> <4AD4D8B6.6010700@cs.helsinki.fi>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009, Pekka Enberg wrote:

> I wonder how reliable these numbers are. We did similar testing a while back
> because we thought kmalloc-96 caches had weird cache behavior but finally
> figured out the anomaly was explained by the order of the tests run, not cache
> size.

The tests were all run directly after booting the respective kernel.
