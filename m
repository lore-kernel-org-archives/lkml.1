Return-Path: <linux-kernel-owner+w=401wt.eu-S1763526AbXGQAqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763526AbXGQAqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 20:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756203AbXGQAqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 20:46:24 -0400
Received: from ozlabs.org ([203.10.76.45]:33719 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968AbXGQAqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 20:46:23 -0400
Subject: Re: [Xen-devel] [patch 17/44] Add nosegneg capability to the
	vsyscall page notes
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Linus Torvalds <torvalds@linux-foundation.com>,
       Zachary Amsden <zach@vmware.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Xen-devel <xen-devel@lists.xensource.com>, Andi Kleen <ak@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Ian Pratt <ian.pratt@xensource.com>,
       Andrew Morton <akpm@linux-foundation.com>,
       Ulrich Drepper <drepper@redhat.com>, Roland McGrath <roland@redhat.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
In-Reply-To: <20070716232914.029797000@xensource.com>>
References: <20070716231536.937393000@xensource.com> >
	  <20070716232914.029797000@xensource.com>>
Content-Type: text/plain
Date: Tue, 17 Jul 2007 10:45:55 +1000
Message-Id: <1184633155.5955.29.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-16 at 16:15 -0700, Jeremy Fitzhardinge wrote:
> plain text document attachment (xen-vsyscall-note.patch)
> Add the "nosegneg" fake capabilty to the vsyscall page notes. This is
> used by the runtime linker to select a glibc version which then
> disables negative-offset accesses to the thread-local segment via
> %gs. These accesses require emulation in Xen (because segments are
> truncated to protect the hypervisor address space) and avoiding them
> provides a measurable performance boost.

Hmm, this is still unconditional?  Not that it causes any measurable
slowdown when enabled, but ISTR discussing making this dynamic...

Rusty.


