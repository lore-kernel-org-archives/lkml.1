Return-Path: <linux-kernel-owner+w=401wt.eu-S1760362AbZAWCJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760362AbZAWCJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 21:09:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755590AbZAWCJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 21:09:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:42377 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755177AbZAWCJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 21:09:25 -0500
Message-ID: <497926C2.4090203@kernel.org>
Date: Fri, 23 Jan 2009 11:09:06 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] x86: Merge hardirq.h
References: <73c1f2160901220533n53cdbb33q2eec14d47176533d@mail.gmail.com>
In-Reply-To: <73c1f2160901220533n53cdbb33q2eec14d47176533d@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 23 Jan 2009 02:09:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Gerst wrote:
> This patch series merges the 32-bit and 64-bit hardirq.h headers and
> does several associated cleanups.  Based on tip/core/percpu.
> 
>  arch/x86/include/asm/hardirq.h    |   49 ++++++++++++++++++++++++++++++++++---
>  arch/x86/include/asm/hardirq_32.h |   33 -------------------------
>  arch/x86/include/asm/hardirq_64.h |   39 -----------------------------
>  arch/x86/kernel/efi_64.c          |    1 +
>  arch/x86/kernel/irq_64.c          |    1 +
>  arch/x86/kernel/process_32.c      |    1 -
>  6 files changed, 47 insertions(+), 77 deletions(-)

Patch tree reviewed and imported into the following git tree (sync
seems slow today if it doesn't appear please pull directly from
master)

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu

with the following changes.

* commit messages modified according to x86-ism
* added missing #include <asm/apic.h> to mce_intel_64.c for patch 0002

Thanks.

-- 
tejun
