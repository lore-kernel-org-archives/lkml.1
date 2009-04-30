Return-Path: <linux-kernel-owner+w=401wt.eu-S1764029AbZD3Ow2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764029AbZD3Ow2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 10:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763963AbZD3Ovz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 10:51:55 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:34330 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763861AbZD3Ovx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 10:51:53 -0400
Date: Thu, 30 Apr 2009 10:42:07 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Ingo Molnar <mingo@elte.hu>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, thomas.pi@arcor.dea,
       Yuriy Lalym <ylalym@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ltt-dev@lists.casi.polymtl.ca, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] Fix dirty page accounting in
 redirty_page_for_writepage()
In-Reply-To: <20090430143215.GE14696@elte.hu>
Message-ID: <alpine.DEB.1.10.0904301034370.4028@qirst.com>
References: <20090429232546.GB15782@Krystal> <alpine.LFD.2.00.0904291701450.22156@localhost.localdomain> <20090430024303.GB19875@Krystal> <alpine.DEB.1.10.0904300921290.22262@qirst.com> <20090430133859.GB8329@elte.hu> <20090430135005.GA5922@Krystal>
 <20090430143215.GE14696@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009, Ingo Molnar wrote:

> Christoph's zero-based x86 percpu patches were incomplete and never
> worked reliably - Christoph unfortunately never addressed the
> bugs/crashes i reported. (and Mike Travis and me injected quite a
> bit of testing into it) There were two failed attempts to productize
> them and the patches just bitrotted for more than a year.

Sorry not my issue. Mike took over that work on the x86 arch.

I am fine with how things developed. The core patches fell off the
priority list after job change. Just get the things that are not right now
straightened out.


