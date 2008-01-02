Return-Path: <linux-kernel-owner+w=401wt.eu-S1754464AbYABR6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbYABR6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 12:58:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbYABR6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 12:58:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbYABR6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 12:58:31 -0500
Date: Wed, 2 Jan 2008 12:56:06 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
       "K. Prasad" <prasad@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, dipankar@in.ibm.com, ego@in.ibm.com,
       mathieu.desnoyers@polymtl.ca, paulmck@linux.vnet.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] Markers Implementation for Preempt RCU Boost Tracing
Message-ID: <20080102175606.GD11496@redhat.com>
References: <20071231060911.GB6461@in.ibm.com> <20071231102045.GB30380@elte.hu> <y0modc4vr7a.fsf@ton.toronto.redhat.com> <20080102124734.GC11208@elte.hu> <20080102163309.GC11496@redhat.com> <20080102170157.GA11161@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080102170157.GA11161@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Wed, Jan 02, 2008 at 06:01:57PM +0100, Ingo Molnar wrote:
> [...]
> well, -freorder-blocks seems to be default-enabled at -O2 on gcc 4.2, so 
> we should already be getting that, right?

Right.

> [...]  So it would be nice if we could collect all this offline code
> and stuff it away into another portion of the kernel image. (or,
> into another portion of the object file - which would still be good
> enough in practice)

That would be the -freorder-blocks-and-partition flag, as proposed by
Arjan two Februarys ago.  I don't see any traces of Andi's overriding
"-fno-reorder-blocks" in the current linus tree, so maybe it's time to
resurrect this one:

http://readlist.com/lists/vger.kernel.org/linux-kernel/39/196123.html

- FChE
