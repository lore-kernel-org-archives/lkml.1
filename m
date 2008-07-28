Return-Path: <linux-kernel-owner+w=401wt.eu-S1758417AbYG1O5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758417AbYG1O5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 10:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757733AbYG1Ozx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 10:55:53 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:45258 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757713AbYG1Ozw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 10:55:52 -0400
Date: Mon, 28 Jul 2008 15:54:30 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Ingo Molnar <mingo@elte.hu>
cc: Mike Travis <travis@sgi.com>, Ben Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Linuxppc-dev@ozlabs.org, Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: CONFIG_FRAME_POINTER [was [PATCH] x86: BUILD_IRQ say .text]
In-Reply-To: <20080728144133.GH18144@elte.hu>
Message-ID: <Pine.LNX.4.64.0807281550260.25371@blonde.site>
References: <Pine.LNX.4.64.0807211828470.26173@blonde.site>
 <20080724104459.GI28817@elte.hu> <Pine.LNX.4.64.0807251839190.20617@blonde.site>
 <20080728144133.GH18144@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008, Ingo Molnar wrote:
> * Hugh Dickins <hugh@veritas.com> wrote:
> 
> > I rather think CONFIG_FRAME_POINTER shouldn't exist at all (or be a 
> > private, config-user-invisible, specific-to-a-few-arches thing): what 
> > one wants to configure is how far to sacrifice cpu performance and 
> > kernel smallness to getting a good stacktrace.  Frame pointer is just 
> > an implementation detail on that, appropriate to some arches. Perhaps 
> > three settings: no stacktrace, fair stacktrace, best stacktrace.
> 
> actually, we consciously use and rely on frame pointers on x86. The 
> runtime cost on 64-bit is miniscule and the improved backtrace output in 
> recent kernels makes backtraces _much_ easier to interpret:

Just to clarify, no way was I criticizing the use of frame pointers
on x86.  What I don't care for is that CONFIG_FRAME_POINTER is used
by common code (e.g. top level Makefile, and various debug Kconfigs),
when I see it as an arch-specific technique for getting best stacktrace.

Hugh
