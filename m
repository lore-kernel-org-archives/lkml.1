Return-Path: <linux-kernel-owner+w=401wt.eu-S1763192AbXKPCtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763192AbXKPCtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 21:49:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753542AbXKPCtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 21:49:12 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:35076 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756416AbXKPCtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 21:49:11 -0500
Message-ID: <473D04DA.9060305@cosmosbay.com>
Date: Fri, 16 Nov 2007 03:47:54 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, torvalds@linux-foundation.org
Subject: Re: [PATCHv2 2/4] x86&x86-64 support for sys_indirect
References: <200711151822.lAFIMVvW028590@devserv.devel.redhat.com>
In-Reply-To: <200711151822.lAFIMVvW028590@devserv.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Fri, 16 Nov 2007 03:47:59 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper a écrit :
> This part adds support for sys_indirect on x86 and x86-64.
> 
>  arch/x86/ia32/ia32entry.S            |    1 +
>  b/arch/x86/kernel/syscall_table_32.S |    1 +
>  b/include/asm-x86/indirect.h         |    5 +++++
>  b/include/asm-x86/indirect_32.h      |   23 +++++++++++++++++++++++
>  b/include/asm-x86/indirect_64.h      |   24 ++++++++++++++++++++++++
>  b/include/asm-x86/unistd_32.h        |    3 ++-
>  b/include/asm-x86/unistd_64.h        |    2 ++
>  7 files changed, 58 insertions(+), 1 deletion(-)

I am not sure how compat is handled ? (ie running a 32bit task in a 64bit kernel)


