Return-Path: <linux-kernel-owner+w=401wt.eu-S1757506AbZDRVKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506AbZDRVKk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 17:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755092AbZDRVKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 17:10:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:60837 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645AbZDRVKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 17:10:04 -0400
Message-ID: <49EA4189.9040204@kernel.org>
Date: Sat, 18 Apr 2009 14:09:29 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, tglx@linutronix.de, gorcunov@gmail.com,
       mingo@elte.hu
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/apic] x86: smpboot - wakeup_secondary should be done
 via __cpuinit section
References: <20090418194528.GD25510@lenovo> <tip-1f51f72326c4d16f402bdfed99c8dae20eb67863@git.kernel.org>
In-Reply-To: <tip-1f51f72326c4d16f402bdfed99c8dae20eb67863@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tip-bot for Cyrill Gorcunov wrote:
> Commit-ID:  1f51f72326c4d16f402bdfed99c8dae20eb67863
> Gitweb:     http://git.kernel.org/tip/1f51f72326c4d16f402bdfed99c8dae20eb67863
> Author:     Cyrill Gorcunov <gorcunov@gmail.com>
> AuthorDate: Sat, 18 Apr 2009 23:45:28 +0400
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Sat, 18 Apr 2009 22:58:58 +0200
> 
> x86: smpboot - wakeup_secondary should be done via __cpuinit section
> 
> A caller (do_boot_cpu) already has __cpuinit attribute.
> 
> Since HOTPLUG_CPU depends on SMP && HOTPLUG it doesn't
> lead to panic at moment.
> 
> [ Impact: cleanup ]
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> LKML-Reference: <20090418194528.GD25510@lenovo>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  arch/x86/kernel/smpboot.c |    4 ++--

there are other two in numaq and es7000.

can you fix them too?

YH

