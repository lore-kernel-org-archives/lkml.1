Return-Path: <linux-kernel-owner+w=401wt.eu-S1755151AbZCFKqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbZCFKqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 05:46:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753789AbZCFKqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 05:46:13 -0500
Received: from casper.infradead.org ([85.118.1.10]:51804 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbZCFKqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 05:46:13 -0500
Subject: Re: [patch 2/2] lockdep: initialize lockdep debugging statistics
From: Peter Zijlstra <peterz@infradead.org>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0903060221500.25972@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903050222160.30401@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.0903050223240.30401@chino.kir.corp.google.com>
	 <1236250159.4228.186.camel@laptop> <20090305110522.GI32407@elte.hu>
	 <alpine.DEB.2.00.0903051355010.25505@chino.kir.corp.google.com>
	 <1236328083.5187.1213.camel@laptop>
	 <alpine.DEB.2.00.0903060149540.26215@chino.kir.corp.google.com>
	 <1236334756.6326.106.camel@laptop>
	 <alpine.DEB.2.00.0903060221500.25972@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 11:46:03 +0100
Message-Id: <1236336363.6326.139.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-06 at 02:27 -0800, David Rientjes wrote:
> That's the point about good software engineering practices: atomic_t 
> should not be assumed to be another int. 

We do, and its a rather fundamental assumption. Any implementation not
conforming is deemed buggy -- esp on the 0 property.

http://lkml.org/lkml/2008/10/28/216

