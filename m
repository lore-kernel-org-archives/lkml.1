Return-Path: <linux-kernel-owner+w=401wt.eu-S1756473AbZCME2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473AbZCME2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 00:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750884AbZCME2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 00:28:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:40760 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbZCME2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 00:28:04 -0400
Subject: Re: [tip:x86/mtrr] x86: more MTRR debug printouts
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-8ad9790588ee2e69118b2b294ddab6f3f0379ad9@git.kernel.org>
References: <49B9BA5A.40108@kernel.org>
	 <tip-8ad9790588ee2e69118b2b294ddab6f3f0379ad9@git.kernel.org>
Content-Type: text/plain
Date: Fri, 13 Mar 2009 09:56:50 +0530
Message-Id: <1236918410.2553.5.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-13 at 02:34 +0000, Yinghai Lu wrote:
> Commit-ID:  8ad9790588ee2e69118b2b294ddab6f3f0379ad9
> Gitweb:     http://git.kernel.org/tip/8ad9790588ee2e69118b2b294ddab6f3f0379ad9
> Author:     Yinghai Lu <yinghai@kernel.org>
> AuthorDate: Thu, 12 Mar 2009 18:43:54 -0700
> Commit:     Ingo Molnar <mingo@elte.hu>
> CommitDate: Fri, 13 Mar 2009 02:52:18 +0100
> 
> x86: more MTRR debug printouts
> 
> Impact: improve MTRR debugging messages
> 
> There's still inefficiencies suspected with the MTRR sanitizing
> code, so make sure we get all the info we need from a dmesg.
> 
> - Remove unneeded mtrr_show
> 
>  (It will only printout one time by first cpu, so it is no big deal.)
> 
> - Also print out directly from get_mtrr, because it doesn't update mtrr_state.
> 

Is there any worth moving these debug functions to
arch/x86/kernel/cpu/cpu_debug.c

By little bit changes you can desired results through:
print_msr(NULL, cpu, CPU_MTRR);

More cpu's flag available at:
arch/x86/include/asm/cpu_debug.h

by using cpu_debug you can read/write registers through kernel/user
mode.

Thanks,
--
JSR

