Return-Path: <linux-kernel-owner+w=401wt.eu-S1752861AbZK3P33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbZK3P33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 10:29:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbZK3P31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 10:29:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230AbZK3P31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 10:29:27 -0500
Date: Mon, 30 Nov 2009 10:29:10 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, utrace-devel <utrace-devel@redhat.com>,
       Roland McGrath <roland@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [RFC] [PATCH] In-kernel gdbstub based on utrace Infrastructure.
Message-ID: <20091130152910.GB10331@redhat.com>
References: <20091130120345.GA18879@linux.vnet.ibm.com> <1259582952.20516.209.camel@laptop> <20091130123257.GB18879@linux.vnet.ibm.com> <1259584907.20516.246.camel@laptop> <20091130131928.GC18879@linux.vnet.ibm.com> <1259588232.20516.307.camel@laptop> <20091130150314.GA10331@redhat.com> <20091130151650.GA24316@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091130151650.GA24316@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 04:16:50PM +0100, Ingo Molnar wrote:
> [...]
> kgdb exists here and today in the kernel and you cannot just build a 
> facility that doesnt replace it and doesnt integrate well with it.

Surely you don't mean that: every non-kgdb facility in the kernel
meets that definition, even all debugging-related facilities such as
perf and ftrace.


> So if a unified user/kernel model for debugging is a 'long term'
> feature in your view then perhaps this framework (which introduces
> _extensive_ hooks all around the kernel) is not designed/approached
> in the right way and should not be merged in this form.

Which "this framework" are you talking about?  Please clarify what
exactly you're trying to say.


- FChE
