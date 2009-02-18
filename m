Return-Path: <linux-kernel-owner+w=401wt.eu-S1756719AbZBRXeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719AbZBRXeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 18:34:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751685AbZBRXeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 18:34:15 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54182 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbZBRXeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 18:34:14 -0500
Date: Wed, 18 Feb 2009 18:34:02 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jason Baron <jbaron@redhat.com>, mingo@elte.hu, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
       fweisbec@gmail.com, fche@redhat.com, compudj@krystal.dyndns.org
Subject: Re: [PATCH] new irq tracer
Message-ID: <20090218233402.GF17272@bombadil.infradead.org>
References: <20090218195328.GA3112@redhat.com> <1234991725.4799.1.camel@laptop> <20090218213545.GB3112@redhat.com> <1234993580.4799.11.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234993580.4799.11.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 10:46:20PM +0100, Peter Zijlstra wrote:
> Much of the other data is already available, /proc/interrupts will
> happily tell you the source of your interrupt storm. The irq-off latency
> tracer will tell you if stuff takes too much time, the graph tracer can
> tell you what is taking how much time.
> 

How so? It will only tell you which irq line you need to be looking at,
not which handlers device is spewing the IRQs...

Perhaps I'm missing something obvious, but that's what I've used a
similar instrument for.

regards, Kyle
