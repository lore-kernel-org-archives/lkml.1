Return-Path: <linux-kernel-owner+w=401wt.eu-S1423170AbXDXWf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423170AbXDXWf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 18:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423177AbXDXWf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 18:35:58 -0400
Received: from [70.254.190.220] ([70.254.190.220]:55947 "EHLO server.willdawg"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423170AbXDXWf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 18:35:57 -0400
Date: Tue, 24 Apr 2007 22:35:54 +0000 (GMT)
From: William Heimbigner <icxcnika@mar.tar.cc>
X-X-Sender: icxcnika@server.thyself
To: Dave Jones <davej@redhat.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] [PATCH] cpufreq: allow full selection of default governors
In-Reply-To: <20070424211253.GG23598@redhat.com>
Message-ID: <Pine.LNX.4.64.0704242232280.25153@server.thyself>
References: <Pine.LNX.4.64.0704242057430.25153@server.thyself>
 <20070424211253.GG23598@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007, Dave Jones wrote:
> On Tue, Apr 24, 2007 at 09:03:23PM +0000, William Heimbigner wrote:
> > The following patches should allow selection of conservative, powersave, and
> > ondemand in the kernel configuration.
>
> This has been rejected several times already.
> Ondemand and conservative isn't a viable governor for all cpufreq implementations
> (ie, ones with high switching latencies).  Also, see the comment in the Kconfig
> a few lines above where you are adding this.
>
> 	Dave

It may be wise to disable the selection of ondemand, however, conservative was 
designed to fix the very problem created by ondemand (the need for high 
switching latencies), and this also says nothing about powersave.

Additionally, it seems odd that the kernel would be left in an undefined state 
if a governor failed to initalize - rather, shouldn't the governor fail in such 
a way as to not cause errors?

William Heimbigner
icxcnika@mar.tar.cc
