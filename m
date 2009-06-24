Return-Path: <linux-kernel-owner+w=401wt.eu-S1752394AbZFXBbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbZFXBbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 21:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbZFXBbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 21:31:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50143 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbZFXBbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 21:31:39 -0400
Date: Tue, 23 Jun 2009 21:31:37 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Paul Mundt <lethal@linux-sh.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] sh updates for 2.6.31-rc1, part 3.
Message-ID: <20090624013137.GC3101@bombadil.infradead.org>
References: <20090623184032.GA713@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623184032.GA713@linux-sh.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 03:40:33AM +0900, Paul Mundt wrote:
>       sh: Fix up HAVE_PERF_COUNTERS typo.
> 

just fyi while wiring this up myself...

Your set_perf_counter_pending when CONFIG_PERF_COUNTERS=y is wrong,
as it's a extern in <linux/perf_counters.h>, you'll probably want to
make it a static inline. (Yeah, I blagged your header. ;-)

cheers, Kyle
