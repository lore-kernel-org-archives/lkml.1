Return-Path: <linux-kernel-owner+w=401wt.eu-S1759111AbXJLMIC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759111AbXJLMIC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 08:08:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbXJLMHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 08:07:53 -0400
Received: from mx12.go2.pl ([193.17.41.142]:55243 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753648AbXJLMHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 08:07:52 -0400
Date: Fri, 12 Oct 2007 14:10:43 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: [rfc][patch 3/3] x86: optimise barriers
Message-ID: <20071012121043.GG1962@ff.dom.local>
References: <20071004052348.GC15131@wotan.suse.de> <20071012082534.GB1962@ff.dom.local> <20071012085733.GA19237@wotan.suse.de> <20071012095505.GD1962@ff.dom.local> <20071012104238.GD19237@wotan.suse.de> <20071012115510.GF1962@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071012115510.GF1962@ff.dom.local>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2007 at 01:55:10PM +0200, Jarek Poplawski wrote:
> On Fri, Oct 12, 2007 at 12:42:38PM +0200, Nick Piggin wrote:
...
> > [...] If you can actually come up with a test
> > case that triggers load/load or store/store reordering, I'm sure
> > Intel / AMD would like to see it ;)
> 
> It seems, after testing only (plus no official spec against this idea),

(...plus of course proper smp_rmb & smp_wmb vs. smp_mb interpretation
probably available from Paul McKenney or Davide Libenzi before this
Intel spec, as well...)

Jarek P.
