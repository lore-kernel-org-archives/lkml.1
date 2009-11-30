Return-Path: <linux-kernel-owner+w=401wt.eu-S1752998AbZK3NhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbZK3NhT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 08:37:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbZK3NhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 08:37:19 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57452 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbZK3NhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 08:37:18 -0500
Subject: Re: [RFC] [PATCH] In-kernel gdbstub based on utrace Infrastructure.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       utrace-devel <utrace-devel@redhat.com>,
       Roland McGrath <roland@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
In-Reply-To: <20091130131928.GC18879@linux.vnet.ibm.com>
References: <20091130120345.GA18879@linux.vnet.ibm.com>
	 <1259582952.20516.209.camel@laptop>
	 <20091130123257.GB18879@linux.vnet.ibm.com>
	 <1259584907.20516.246.camel@laptop>
	 <20091130131928.GC18879@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Nov 2009 14:37:12 +0100
Message-ID: <1259588232.20516.307.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-30 at 18:49 +0530, Srikar Dronamraju wrote:

> This is suppose to be one of the interfaces to use utrace, i.e Allow
> gdb to use utrace features without having to change gdb itself.
> Though there are not enough features in this patch, intentions include
> support multi-threaded debugging, concurrent debugger support for same
> process, syscall tracing.
> 
> For Breakpoint support(not yet submitted to LKML), it would use
> execution out of line rather than the conventional inline-single
> stepping.
> 
> I guess Christoph, Roland and Frank would be able to explain in a better
> fashion the rational and advantages of this stub over convential gdb.

Hmm,. wouldn't it make much more sense to extend the current kgdb stub
to include userspace debugging, providing an all-in-one solution?

I think it would be much more powerful to be able to observe the full
software stack and not be limited by this user<->kernel barrier.

(Provided the user has sufficient privileges of course).

