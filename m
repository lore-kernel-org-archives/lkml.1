Return-Path: <linux-kernel-owner+w=401wt.eu-S1756598AbYCUOH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbYCUOH7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 10:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754240AbYCUOHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 10:07:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53175 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbYCUOHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 10:07:46 -0400
Date: Fri, 21 Mar 2008 10:07:08 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Roland McGrath <roland@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       Richard Henderson <rth@twiddle.net>, tony.luck@intel.com,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH 6/8] ptrace: arch_ptrace -ENOSYS return
Message-ID: <20080321140708.GA30540@infradead.org>
References: <20080319211714.8B14226F995@magilla.localdomain> <20080319212024.EA03126F995@magilla.localdomain> <alpine.LFD.1.00.0803191935080.3020@woody.linux-foundation.org> <20080320081658.0B23826F995@magilla.localdomain> <alpine.LFD.1.00.0803211441180.3781@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803211441180.3781@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 02:50:01PM +0100, Thomas Gleixner wrote:
> What about adding a CONFIG_ARCH_HAS_PTRACE2, which is set by the archs
> which are converted. For those which are not you add a fallback
> implementation:

Bah.  Folks, we're talking about adding a single new argument to a
single function implemented by our 24 architectures.  This is a trivial
almost scriptable conversion.

