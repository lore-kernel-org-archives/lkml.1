Return-Path: <linux-kernel-owner+w=401wt.eu-S1030978AbXDPVON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030978AbXDPVON (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 17:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030973AbXDPVON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 17:14:13 -0400
Received: from cantor.suse.de ([195.135.220.2]:40285 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030978AbXDPVOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 17:14:12 -0400
To: John <linux.kernel@free.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Disabling x86 System Management Mode
References: <46235447.3080000@free.fr>
From: Andi Kleen <andi@firstfloor.org>
Date: 17 Apr 2007 00:12:21 +0200
In-Reply-To: <46235447.3080000@free.fr>
Message-ID: <p73odlo55q2.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John <linux.kernel@free.fr> writes:

Please use a full real name for posting.

> AFAIU, even a hard real-time OS is "defenseless" against SMIs that
> kick the CPU into SMM.

There are usually chipset specific bits that can be set to disable SMMs.
See the datasheet if you can get them. Unfortunately most chipset vendors
don't give out data sheets easily.

> .globl foo
> foo:
>    push %ebx
>    push %esi
>    cpuid
>    rdtsc

At least some SMM implementations restore the old TSC value. Sad but true.
Besides RDTSC can be speculated around on some CPUs which also adds errors.

-Andi
