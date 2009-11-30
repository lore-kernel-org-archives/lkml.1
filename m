Return-Path: <linux-kernel-owner+w=401wt.eu-S1752290AbZK3PD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290AbZK3PD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 10:03:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbZK3PDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 10:03:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbZK3PDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 10:03:25 -0500
Date: Mon, 30 Nov 2009 10:03:14 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, utrace-devel <utrace-devel@redhat.com>,
       Roland McGrath <roland@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [RFC] [PATCH] In-kernel gdbstub based on utrace Infrastructure.
Message-ID: <20091130150314.GA10331@redhat.com>
References: <20091130120345.GA18879@linux.vnet.ibm.com> <1259582952.20516.209.camel@laptop> <20091130123257.GB18879@linux.vnet.ibm.com> <1259584907.20516.246.camel@laptop> <20091130131928.GC18879@linux.vnet.ibm.com> <1259588232.20516.307.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259588232.20516.307.camel@laptop>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

peterz wrote: 

> Hmm,. wouldn't it make much more sense to extend the current kgdb stub
> to include userspace debugging, providing an all-in-one solution?
> I think it would be much more powerful to be able to observe the full
> software stack and not be limited by this user<->kernel barrier.

There exist other tools for this broad a scope (systemtap being one),
and present gdb is not well suited for this.  That makes this idea an
exciting potential for the future, but not a practical short-term
goal.

- FChE
