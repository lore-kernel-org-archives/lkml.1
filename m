Return-Path: <linux-kernel-owner+w=401wt.eu-S1760213AbYA1JNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760213AbYA1JNu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 04:13:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756139AbYA1JNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 04:13:33 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45920 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584AbYA1JNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 04:13:31 -0500
Subject: Re: [CPUISOL] CPU isolation extensions
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: maxk@qualcomm.com
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <srostedt@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>, Paul Jackson <pj@sgi.com>
In-Reply-To: <1201493382-29804-1-git-send-email-maxk@qualcomm.com>
References: <1201493382-29804-1-git-send-email-maxk@qualcomm.com>
Content-Type: text/plain
Date: Mon, 28 Jan 2008 10:08:25 +0100
Message-Id: <1201511305.6149.30.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ You really ought to CC people :-) ]

On Sun, 2008-01-27 at 20:09 -0800, maxk@qualcomm.com wrote:
> Following patch series extends CPU isolation support. Yes, most people want to virtuallize 
> CPUs these days and I want to isolate them :).
> The primary idea here is to be able to use some CPU cores as dedicated engines for running
> user-space code with minimal kernel overhead/intervention, think of it as an SPE in the 
> Cell processor.
> 
> We've had scheduler support for CPU isolation ever since O(1) scheduler went it. 
> I'd like to extend it further to avoid kernel activity on those CPUs as much as possible.
> In fact that the primary distinction that I'm making between say "CPU sets" and 
> "CPU isolation". "CPU sets" let you manage user-space load while "CPU isolation" provides
> a way to isolate a CPU as much as possible (including kernel activities).

Ok, so you're aware of CPU sets, miss a feature, but instead of
extending it to cover your needs you build something new entirely?

> I'm personally using this for hard realtime purposes. With CPU isolation it's very easy to 
> achieve single digit usec worst case and around 200 nsec average response times on off-the-shelf
> multi- processor/core systems under exteme system load. I'm working with legal folks on releasing 
> hard RT user-space framework for that.
> I can also see other application like simulators and stuff that can benefit from this.

have you been using just this, or in combination with the -rt effort?


