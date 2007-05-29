Return-Path: <linux-kernel-owner+w=401wt.eu-S1761302AbXE2NWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761302AbXE2NWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 09:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbXE2NWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 09:22:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49437 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbXE2NWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 09:22:04 -0400
Date: Tue, 29 May 2007 14:21:58 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Bill Huey <billh@gnuppy.monkey.org>,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] lockdep: sanitise CONFIG_PROVE_LOCKING
Message-ID: <20070529132158.GA2192@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, Bill Huey <billh@gnuppy.monkey.org>,
	Jason Baron <jbaron@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>
References: <20070529125248.877196281@chello.nl> <20070529130106.864404378@chello.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070529130106.864404378@chello.nl>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 02:52:50PM +0200, Peter Zijlstra wrote:
> Ensure that all of the lock dependency tracking code is under
> CONFIG_PROVE_LOCKING. This allows us to use the held lock tracking code
> for other purposes.

There's an awfull lot of ifdefs introduced in this patch, I wonder
whether it might be better to split up lockdep.c at those boundaries.

