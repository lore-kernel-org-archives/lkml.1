Return-Path: <linux-kernel-owner+w=401wt.eu-S1758153AbYGQNfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153AbYGQNfR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 09:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755814AbYGQNfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 09:35:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58104 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679AbYGQNfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 09:35:05 -0400
Date: Thu, 17 Jul 2008 09:34:26 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       hch@infradead.org
Subject: Re: [PATCH 01/23] tracehook: add linux/tracehook.h
Message-ID: <20080717133426.GA9577@infradead.org>
References: <20080717072541.F390E15411D@magilla.localdomain> <20080717072755.E2FBC15411D@magilla.localdomain> <20080717084818.GA5637@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080717084818.GA5637@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 12:48:18PM +0400, Alexey Dobriyan wrote:
> > The new linux/ptrace.h inlines are used by the following patches in the
> > new tracehook_*() inlines.  Using these helpers for the ptrace event
> > stops makes it simple to change or disable the old ptrace implementation
> > of these stops conditionally later.
> 
> Call them "utrace_*" from the start?

Yes, please.

> Pointless 1:1 wrapper unless you're going to #ifdef ->ptrace later.

Even then I don't think it's a good idea.  This one should only be
touched in very very few places

