Return-Path: <linux-kernel-owner+w=401wt.eu-S1758740AbZJHQTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758740AbZJHQTL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 12:19:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758416AbZJHQTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 12:19:10 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:51122 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757892AbZJHQTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 12:19:09 -0400
Date: Thu, 8 Oct 2009 12:11:48 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Peter Zijlstra <peterz@infradead.org>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>, Tejun Heo <tj@kernel.org>,
       Mel Gorman <mel@csn.ul.ie>, mingo@elte.hu
Subject: Re: [this_cpu_xx V5 19/19] SLUB: Experimental new fastpath w/o
 interrupt disable
In-Reply-To: <1254988350.26976.256.camel@twins>
Message-ID: <alpine.DEB.1.10.0910081211050.21951@gentwo.org>
References: <20091006233654.815079668@gentwo.org>  <20091006233733.153341605@gentwo.org> <20091007025440.GB4664@Krystal>  <1254906707.26976.225.camel@twins> <20091007124628.GB27363@Krystal>  <alpine.DEB.1.10.0910071039520.5671@gentwo.org>  <20091007150257.GA8508@Krystal>
  <alpine.DEB.1.10.0910071102590.9984@gentwo.org>  <20091007151940.GA10052@Krystal>  <alpine.DEB.1.10.0910071119450.9296@gentwo.org> <1254988350.26976.256.camel@twins>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Oct 2009, Peter Zijlstra wrote:

> > 	preempt_enable_no_sched()
>
> NACK, delaying the reschedule is not an option

I ended up just doing a preempt_disable() at the beginning and a
preempt_disable() at the end. That should be easily reviewable.

