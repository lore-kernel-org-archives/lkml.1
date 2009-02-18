Return-Path: <linux-kernel-owner+w=401wt.eu-S1754568AbZBREue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbZBREue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 23:50:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbZBREuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 23:50:25 -0500
Received: from ozlabs.org ([203.10.76.45]:43733 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbZBREuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 23:50:24 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/4] generic-smp: remove kmalloc usage
Date: Wed, 18 Feb 2009 15:20:16 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>
References: <20090216163847.431174825@chello.nl> <1234859071.4744.10.camel@laptop> <20090217094359.GA1231@elte.hu>
In-Reply-To: <20090217094359.GA1231@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902181520.17504.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 February 2009 20:13:59 Ingo Molnar wrote:
> We should not bend backwards trying to preserve that kmalloc() 
> [and prove that it's safe and race-free] - i.e. the burden of 
> proof is on the person insisting that it's needed, not on the 
> person wanting to remove it.

Respectfully disagree.  The kmalloc has been there for a very long time,
and doing fine AFAICT.

If the replacement is going to be subtle and tricksy, it had damn well
better be faster not just some geek code wank!

Cheers,
Rusty.
