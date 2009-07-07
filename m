Return-Path: <linux-kernel-owner+w=401wt.eu-S1757921AbZGGPeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921AbZGGPeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 11:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756092AbZGGPeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 11:34:03 -0400
Received: from viefep15-int.chello.at ([62.179.121.35]:26592 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448AbZGGPeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 11:34:01 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 1/3] Increase lockdep limits: MAX_STACK_TRACE_ENTRIES
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Joao Correia <joaomiguelcorreia@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>
In-Reply-To: <a5d9929e0907070825j1dda6584t93196e2730dedc5c@mail.gmail.com>
References: <a5d9929e0907070825j1dda6584t93196e2730dedc5c@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 17:33:56 +0200
Message-Id: <1246980836.9777.5.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-07 at 16:25 +0100, Joao Correia wrote:
> (Applies to current Linus tree, as of 2.6.31-rc2)
> 
> As it stands now, the limit is too low and is being hit by false
> positives. Increasing its value will allow for more room to work with.
> 
> This was suggested by Ingo Molnar
> (http://article.gmane.org/gmane.linux.kernel/852005) but never
> submitted as a patch, to the best of my knowledge.

Right, we found a bug in the dma-debug code that generated tons of
classes where only 1 was needed, which in turn generated tons of chains
and stack entries.

But that got merged, but you're seeing more of this?

