Return-Path: <linux-kernel-owner+w=401wt.eu-S932634AbZJHQY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634AbZJHQY0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 12:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932597AbZJHQYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 12:24:25 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:33857 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932579AbZJHQYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 12:24:24 -0400
Date: Thu, 8 Oct 2009 12:17:32 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Peter Zijlstra <peterz@infradead.org>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>, Tejun Heo <tj@kernel.org>,
       Mel Gorman <mel@csn.ul.ie>, mingo@elte.hu
Subject: Re: [this_cpu_xx V5 19/19] SLUB: Experimental new fastpath w/o
 interrupt disable
In-Reply-To: <1255006435.26976.309.camel@twins>
Message-ID: <alpine.DEB.1.10.0910081215300.21951@gentwo.org>
References: <20091006233733.153341605@gentwo.org>  <20091007025440.GB4664@Krystal> <1254906707.26976.225.camel@twins>  <20091007124628.GB27363@Krystal>  <alpine.DEB.1.10.0910071039520.5671@gentwo.org>  <20091007150257.GA8508@Krystal> 
 <alpine.DEB.1.10.0910071102590.9984@gentwo.org>  <20091007151940.GA10052@Krystal>  <alpine.DEB.1.10.0910071119450.9296@gentwo.org>  <1254988350.26976.256.camel@twins>  <20091008124456.GA13307@Krystal> <1255006435.26976.309.camel@twins>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Oct 2009, Peter Zijlstra wrote:

> I just don't get why Christoph is getting all upset about the
> need_resched() check in preempt_enable(), its still cheaper than poking
> at the interrupt flags.

Preempt causes too many performance issues. I keep on thinking that I
could make it easier on people to use it. Guess I better leave it simple
then.



