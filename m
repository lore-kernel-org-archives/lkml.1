Return-Path: <linux-kernel-owner+w=401wt.eu-S1752226AbXA0KTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbXA0KTj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 05:19:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbXA0KTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 05:19:38 -0500
Received: from smtp.osdl.org ([65.172.181.24]:47622 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbXA0KTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 05:19:37 -0500
Date: Sat, 27 Jan 2007 02:18:34 -0800
From: Andrew Morton <akpm@osdl.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       Ingo Molnar <mingo@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Christoph Hellwig <hch@infradead.org>, ltt-dev@shafik.org,
       systemtap@sources.redhat.com, Douglas Niehaus <niehaus@eecs.ku.edu>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       Thomas Gleixner <tglx@linutronix.de>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 00/09] atomic.h : standardizing atomic primitives
Message-Id: <20070127021834.e26e955d.akpm@osdl.org>
In-Reply-To: <11697417541743-git-send-email-mathieu.desnoyers@polymtl.ca>
References: <11697417541743-git-send-email-mathieu.desnoyers@polymtl.ca>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jan 2007 11:15:45 -0500
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> It mainly adds support for missing 64 bits cmpxchg and 64 bits atomic add
> unless. Therefore, principally 64 bits architectures are targeted by these
> patches. It also adds the complete list of atomic operations on the atomic_long
> type.

OK, I fixed eight separate compile errors in this patch series and
now powerpc is being very ugly with a twisty maze of include dependencies.

I'm giving up.  Someone should publish a suite of cross-compilers for us
so stuff like this doesn't need to happen.
