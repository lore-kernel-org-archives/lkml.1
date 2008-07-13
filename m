Return-Path: <linux-kernel-owner+w=401wt.eu-S1754708AbYGMCEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbYGMCEx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 22:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbYGMCEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 22:04:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:26957 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbYGMCEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 22:04:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jHjBiaG/gekl0HRmlNj1BZlVbYoMkoDMge/vOsGGIYcue0HqFovUK9OTz/zYLf7dH5
         8brQ8fRIIvZ3L09gtoCNnTihquevqr0t2LYd9sLibcyNOAhY6AQ0JdItjqc25G8L13Cv
         AwQrvz7xwG8i0seyKLKatNTNgbjgakqercnNQ=
Message-ID: <86802c440807121904m1516b47am22a384a1e5868f68@mail.gmail.com>
Date: Sat, 12 Jul 2008 19:04:44 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Suresh Siddha" <suresh.b.siddha@intel.com>
Subject: Re: [PATCH] x86: let 32bit use apic_ops too
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080713010843.GD1678@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807080141.05436.yhlu.kernel@gmail.com>
	 <200807092017.51004.yhlu.kernel@gmail.com>
	 <200807102038.26591.yhlu.kernel@gmail.com>
	 <200807111841.55403.yhlu.kernel@gmail.com>
	 <20080713010843.GD1678@linux-os.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2008 at 6:08 PM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
> Yinghai,
>
> We can now cleanup ack_APIC_irq() to use the native_apic_mem_write()
> for both 32bit and 64bit

apic_write_around(), in case 32bit not have CONFIG_X86_GOOD_APIC?
or let 64 bit use that apic_write_around()?

>
> And also arch/x86/kernel/ipi.c can also use native_apic_mem_write()
> similar to include/asm-x86/ipi.h

should remove duplicated functions in ipi.c

YH
