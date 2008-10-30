Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbYJ3V1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbYJ3V1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 17:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbYJ3V1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 17:27:17 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42908 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753522AbYJ3V1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 17:27:16 -0400
Subject: Re: [PATCH] x86: fix missing cpu_index initialisation
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20081030212359.GC30303@elte.hu>
References: <1225401217.19324.28.camel@localhost.localdomain>
	 <86802c440810301421t71e88ffm112a7bd361e7920a@mail.gmail.com>
	 <20081030212359.GC30303@elte.hu>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 16:27:13 -0500
Message-Id: <1225402033.19324.38.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-30 at 22:23 +0100, Ingo Molnar wrote:
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
> >   CC      arch/x86/kernel/cpu/common.o
> > arch/x86/kernel/cpu/common.c: In function 'early_identify_cpu':
> > arch/x86/kernel/cpu/common.c:553: error: 'boot_cpu_id' undeclared
> > (first use in this function)
> > arch/x86/kernel/cpu/common.c:553: error: (Each undeclared identifier
> > is reported only once
> > arch/x86/kernel/cpu/common.c:553: error: for each function it appears in.)
> > make[2]: *** [arch/x86/kernel/cpu/common.o] Error 1
> > make[1]: *** [arch/x86/kernel/cpu] Error 2
> > make: *** [arch/x86/kernel] Error 2
> 
> depends on this patch perhaps:
> 
> Subject: [PATCH] fix compile breakage caused by	dc1e35c6e95e8923cf1d3510438b63c600fee1e2

Yes, sorry, that's what the line:


> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> ---
> 
> Depends on [VOYAGER] x86: add ability to test for boot CPU
> 
>  arch/x86/kernel/cpu/common.c        |    2 ++

Was supposed to convey

James


