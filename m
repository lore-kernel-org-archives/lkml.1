Return-Path: <linux-kernel-owner+w=401wt.eu-S1756838AbZFRFti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838AbZFRFti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 01:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbZFRFtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 01:49:31 -0400
Received: from mail-px0-f189.google.com ([209.85.216.189]:54857 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbZFRFtb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 01:49:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mScyFeER9jOWIQSibg2ZJ2FdUvLfWCvg3dnXXbvtlvPtENtQSGzHbJ2JmXHF01z8q5
         DXsxFbD4eei3m0Idnr90hXqTq/k6rIzoX4aiyVGxdYuaYF+38UL7yS0LKDGJ5gTchEZ6
         JAY99RPmnSB8Kbwo3plUeGVP/vb4P/hbgjKBM=
MIME-Version: 1.0
In-Reply-To: <4A3605A2.6000206@jp.fujitsu.com>
References: <4A3601BF.2000201@jp.fujitsu.com> <4A3605A2.6000206@jp.fujitsu.com>
Date: Thu, 18 Jun 2009 13:49:33 +0800
Message-ID: <851fc09e0906172249q40c99fc6n26662b533b063b9e@mail.gmail.com>
Subject: Re: [PATCH 12/16] x86, mce: squash mce_intel.c into therm_throt.c
From: huang ying <huang.ying.caritas@gmail.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/15 Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>:
> move intel_init_thermal() into therm_throt.c
>
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> ---
>  arch/x86/kernel/cpu/mcheck/Makefile      |    2 +-
>  arch/x86/kernel/cpu/mcheck/mce_intel.c   |   73 ------------------------------
>  arch/x86/kernel/cpu/mcheck/therm_throt.c |   66 +++++++++++++++++++++++++++
>  3 files changed, 67 insertions(+), 74 deletions(-)
>  delete mode 100644 arch/x86/kernel/cpu/mcheck/mce_intel.c

Why we need this patch? I think the design principle behind MCE is to
separate vendor/cpu specific code into different files. At least
#ifdef CONFIG_X86_MCE_INTEL should be used around moved code.

Best Regards,
Huang Ying
