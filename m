Return-Path: <linux-kernel-owner+w=401wt.eu-S1754356Ab0AICub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab0AICub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 21:50:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497Ab0AICua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 21:50:30 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:35775 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab0AICu3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 21:50:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ehx3pRdnVYYpug3urB0JdjdW8CeWYTRS0OSLJpvb0TmYc65WnvcwOF6PyOnE1aPVz5
         T+khwe26ajPKsSoonP3wQnZODkObfM2Juzs5ak1wR86WA1R5D/fThbWr7wjes6aJE/7g
         GIjcCHscWQZiHEg7LOR9e8vObJO71BpeitpUI=
MIME-Version: 1.0
In-Reply-To: <4B47E7A9.6090904@zytor.com>
References: <1263002989.2879.664.camel@sbs-t61.sc.intel.com>
	 <4B47E7A9.6090904@zytor.com>
Date: Fri, 8 Jan 2010 18:50:29 -0800
X-Google-Sender-Auth: b19621c52f067d76
Message-ID: <86802c441001081850s4965fca3y4cba3782d3eaeec6@mail.gmail.com>
Subject: Re: [patch] x86, apic: use 0x20 for the IRQ_MOVE_CLEANUP_VECTOR 
	instead of 0x1f
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 8, 2010 at 6:19 PM, H. Peter Anvin <hpa@zytor.com> wrote:

> However, my most serious concern with this patch is that there is a
> fairly significant change due to this patch, which is that the legacy
> IRQ vectors now fall *inside* the FIRST_DEVICE_VECTOR range.  This isn't
> a bad thing -- in fact, it is fundamentally the right thing to do
> especially once we consider platforms which *don't* have the legacy IRQs
> -- but it makes me scared of unexpected behavior changes as a result.
> If you feel confident that that is not the case, could you outline why
> it shouldn't be a problem?
>

if it is not used by ioapic instead of legacy,
do we need to re assign irq0 to irq15 domain from all cpus to
apic->vector_allocation_domain()?

YH
