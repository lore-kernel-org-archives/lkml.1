Return-Path: <linux-kernel-owner+w=401wt.eu-S933221AbYETUNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933221AbYETUNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 16:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759421AbYETUNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 16:13:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759516AbYETUNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 16:13:13 -0400
Date: Tue, 20 May 2008 13:12:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: prasad@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, dwilder@us.ibm.com, hch@infradead.org
Subject: Re: [RFC Patch 1/1] trace_printk and trace_dump interface - v2
Message-Id: <20080520131225.46175b3b.akpm@linux-foundation.org>
In-Reply-To: <op.ubgxivbq03j166@prasadkr_t60p.in.ibm.com>
References: <op.ua9axd2a03j166@prasadkr_t60p.in.ibm.com>
	<op.ua9a1r0y03j166@prasadkr_t60p.in.ibm.com>
	<op.ua90vfwv03j166@prasadkr_t60p.in.ibm.com>
	<20080519162149.50f58b80.akpm@linux-foundation.org>
	<op.ubgxivbq03j166@prasadkr_t60p.in.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008 01:23:09 +0530
"K.Prasad" <prasad@linux.vnet.ibm.com> wrote:

> 
> The name 'trace' (previously GTSC), I gather that it was the chosen after
> much deliberation (http://tinyurl.com/6odoh4), however I'm open to the
> idea of changing the name (say dbg_printk/dbg_dump?).
> 
> Kindly let me know of your suggestions for this, and I will change them
> during the next version.

Well I was just putting it out there for consideration.  Yes, I think
the whole idea of consuming the "trace_*" namespace in this patchset
was ill-advised.

Also, I don't know how to move forward with the whole feature - I
haven't seen a lot of interest from others and I haven't seen much
discussion of how this feature differs from all the other tracing
things which have been floating about.

And even if the proposed patches presently offer unique and useful
features, will one of the other tracing implementations (eg: ltt) later
grow to close that gap?

I'm also a bit dubious about the whole thing based on past experience
with kernel-developer-only in-kernel tools.  People just don't use them
much.  One example: fault injection.

> Will something like this look better?

If it addresses the comment I raised, sure.  Please satisfy yourself
that it does.

