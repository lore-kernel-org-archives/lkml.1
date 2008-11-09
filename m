Return-Path: <linux-kernel-owner+w=401wt.eu-S1755315AbYKIMpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315AbYKIMpv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 07:45:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754680AbYKIMpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 07:45:42 -0500
Received: from ftp.linux-mips.org ([213.58.128.207]:34331 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbYKIMpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 07:45:40 -0500
Date: Sun, 9 Nov 2008 12:45:35 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] x86: apic - calibrate_APIC_clock remove redundant
 irq-enable-disable
In-Reply-To: <4916c290.0437560a.270e.0940@mx.google.com>
Message-ID: <alpine.LFD.1.10.0811091245000.25325@ftp.linux-mips.org>
References: <20081109105709.222708517@gmail.com>> <4916c290.0437560a.270e.0940@mx.google.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Jan 1970, Cyrill Gorcunov wrote:

> Impact: cleanup
> 
> lapic_timer_setup is self-protected with local_irq_save/restore
> no need to use them in caller and levt is the per-cpu variable so
> no concurrent access from another cpu.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> ---
>  arch/x86/kernel/apic.c |    4 ----
>  1 file changed, 4 deletions(-)

Acked-by: Maciej W. Rozycki <macro@linux-mips.org>

 Thanks, Cyrill.

  Maciej
