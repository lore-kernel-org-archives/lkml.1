Return-Path: <linux-kernel-owner+w=401wt.eu-S1758946AbZJGLPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946AbZJGLPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 07:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758928AbZJGLPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 07:15:52 -0400
Received: from ozlabs.org ([203.10.76.45]:53459 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758919AbZJGLPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 07:15:51 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19148.30773.350036.411105@cargo.ozlabs.ibm.com>
Date: Wed, 7 Oct 2009 22:15:01 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: eranian@gmail.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       perfmon2-devel@lists.sf.net
Subject: Re: [PATCH 2/2] perf_events: add event constraints support for
 Intel  processors
In-Reply-To: <1254911461.26976.239.camel@twins>
References: <1254840129-6198-1-git-send-email-eranian@gmail.com>
	<1254840129-6198-2-git-send-email-eranian@gmail.com>
	<1254840129-6198-3-git-send-email-eranian@gmail.com>
	<1254846544.21044.298.camel@laptop>
	<7c86c4470910061026o247c182dwdea7fa7296027@mail.gmail.com>
	<1254911461.26976.239.camel@twins>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> > By design of this API, the user should never be concerned about
> > ordering the events
> > in a group a certain way to get a successful assignment to counters.
> > This should all
> > be handled by the kernel.
> 
> Agreed, the POWER implementation actually does this quite nicely, maybe
> we should borrow some of its code for scheduling groups.

Yeah, I'm quite pleased with how that code turned out, and I'd be
happy to help adapt it for other architectures.  The one design
handles all the POWER PMUs from POWER4 with multiple layers of event
multiplexers feeding an event bus (and some events available through
more than one multiplexer) through to the much simpler and more
straightforward POWER7.

Paul.
