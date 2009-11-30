Return-Path: <linux-kernel-owner+w=401wt.eu-S1752442AbZK3PLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbZK3PLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 10:11:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196AbZK3PLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 10:11:46 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48629 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbZK3PLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 10:11:45 -0500
Subject: Re: [RFC] [PATCH] In-kernel gdbstub based on utrace Infrastructure.
From: Peter Zijlstra <peterz@infradead.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, utrace-devel <utrace-devel@redhat.com>,
       Roland McGrath <roland@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
In-Reply-To: <20091130150314.GA10331@redhat.com>
References: <20091130120345.GA18879@linux.vnet.ibm.com>
	 <1259582952.20516.209.camel@laptop>
	 <20091130123257.GB18879@linux.vnet.ibm.com>
	 <1259584907.20516.246.camel@laptop>
	 <20091130131928.GC18879@linux.vnet.ibm.com>
	 <1259588232.20516.307.camel@laptop>  <20091130150314.GA10331@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Nov 2009 16:11:36 +0100
Message-ID: <1259593896.26472.89.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-30 at 10:03 -0500, Frank Ch. Eigler wrote:
> peterz wrote: 
> 
> > Hmm,. wouldn't it make much more sense to extend the current kgdb stub
> > to include userspace debugging, providing an all-in-one solution?
> > I think it would be much more powerful to be able to observe the full
> > software stack and not be limited by this user<->kernel barrier.
> 
> There exist other tools for this broad a scope (systemtap being one),
> and present gdb is not well suited for this.  That makes this idea an
> exciting potential for the future, but not a practical short-term
> goal.

Who's talking short-term? And if gdb is unsuited, it'll simply have to
get fixed :-)


