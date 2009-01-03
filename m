Return-Path: <linux-kernel-owner+w=401wt.eu-S1759386AbZACAXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759386AbZACAXk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 19:23:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757552AbZACAXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 19:23:31 -0500
Received: from ozlabs.org ([203.10.76.45]:36051 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757105AbZACAXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 19:23:31 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PULL] cpumask tree
Date: Sat, 3 Jan 2009 10:53:24 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
References: <200901011149.18401.rusty@rustcorp.com.au> <alpine.LFD.2.00.0901021149020.5086@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0901021149020.5086@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901031053.25419.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 January 2009 06:36:33 Linus Torvalds wrote:
> 
> On Thu, 1 Jan 2009, Rusty Russell wrote:
> >
> > OK, this is the bulk of the conversion to the new cpumask operators.
> > The x86-specific parts (the most aggressive large-NR_CPUS arch) are going
> > via Ingo's tree.
> 
> This gets lots of conflicts for me. Some of them look simple enough, but 
> not all. io_apic.c gets lots of nasty conflicts, and it _looks_ like I 
> should just pick the version of the file that I already have (because the 
> only thing that comes in from that is yet another merge commit), but 
> kernel/sched.c also gets conflicts in areas with FIXME's etc.
> 
> Rusty, Ingo, can you work this out? I pushed out my current tree.

Yes, some went via Ingo's tree and there are some known overlaps.

I'll clean it up and resend pull req this weekend.

Thanks,
Rusty.
