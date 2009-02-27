Return-Path: <linux-kernel-owner+w=401wt.eu-S1759733AbZB0Aev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759733AbZB0Aev (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 19:34:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbZB0Aem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 19:34:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751206AbZB0Ael (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 19:34:41 -0500
Date: Thu, 26 Feb 2009 16:33:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       eric@lammerts.org
Subject: Re: [PATCH][retry 2] Conform L3 Cache Index Disable to Linux
 standards From:  Eric Lammerts <eric@lammerts.org>
Message-Id: <20090226163329.3a47b368.akpm@linux-foundation.org>
In-Reply-To: <200902201550.47415.mark.langsdorf@amd.com>
References: <200902201550.47415.mark.langsdorf@amd.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Feb 2009 15:50:47 -0600
Mark Langsdorf <mark.langsdorf@amd.com> wrote:

> Add ABI Documentation entry and fix some /sys directory formating
> issues with the L3 Cache Index Disable feature for future AMD
> processors. __Add a check to disable it for family 0x10 models
> that do not support it yet.

x86_64 allnoconfig:

arch/x86/kernel/cpu/intel_cacheinfo.c:556: warning: 'free_cache_attributes' defined but not used
arch/x86/kernel/cpu/intel_cacheinfo.c:596: warning: 'detect_cache_attributes' defined but not used

Fixing these revealed another shower of unused functions.  Fixing those
led to an even bigger shower.

Obviously, the code is a mess and needs some thought, understanding and
restructuring so that mere mortals can correctly modify it.

I'll drop the patches.   Please test version 3 a bit better?
