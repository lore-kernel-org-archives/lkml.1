Return-Path: <linux-kernel-owner+w=401wt.eu-S1762225AbYDSVZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762225AbYDSVZs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 17:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbYDSVZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 17:25:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:54140 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbYDSVZk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 17:25:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=xYmhPhd8YomY8Ty52QfaHU9ilvxPf0DfHlowhro9toHohsqhQCXGSn1Qfa0aKF4iVfwBVSsIcjnx+tsjZjidfLdlmwW1lEoIaIzeUFAQDnOg1akeHmFQBXd403HFUueVoLEKT/7YNI7tVF8FXWHdxZxmKVPNO3cF7XdkVSP+O04=
Date: Sat, 19 Apr 2008 23:25:43 +0200
From: Diego Calleja <diegocg@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-$SHA1: WARNING: at arch/x86/kernel/genapic_64.c:86
 read_apic_id+0x78/0x80()
Message-Id: <20080419232543.6f0dc3ab.diegocg@gmail.com>
In-Reply-To: <20080418223945.GA4801@martell.zuzino.mipt.ru>
References: <20080418223945.GA4801@martell.zuzino.mipt.ru>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Sat, 19 Apr 2008 02:39:45 +0400, Alexey Dobriyan <adobriyan@gmail.com> escribió:

> ------------[ cut here ]------------
> WARNING: at arch/x86/kernel/genapic_64.c:86 read_apic_id+0x78/0x80()
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 2.6.25-2cca775baecbfede2fec20c99add709232311fe7 #3
> 
> Call Trace:
>  [<ffffffff8023150f>] warn_on_slowpath+0x5f/0x80
>  [<ffffffff80299e9e>] ? open_namei+0x4e/0x6b0
>  [<ffffffff804594e5>] ? _spin_unlock_irqrestore+0x65/0x80
>  [<ffffffff80254105>] ? trace_hardirqs_on+0xd5/0x160
>  [<ffffffff804594c2>] ? _spin_unlock_irqrestore+0x42/0x80
>  [<ffffffff8021ed28>] read_apic_id+0x78/0x80
>  [<ffffffff805e7332>] verify_local_APIC+0xb2/0x1a0
>  [<ffffffff805e6193>] native_smp_prepare_cpus+0x1a3/0x390
>  [<ffffffff805e0713>] kernel_init+0x53/0x340
>  [<ffffffff80459536>] ? _spin_unlock_irq+0x36/0x60
>  [<ffffffff80458a92>] ? trace_hardirqs_on_thunk+0x35/0x3a
>  [<ffffffff80254105>] ? trace_hardirqs_on+0xd5/0x160
>  [<ffffffff8020c4b8>] child_rip+0xa/0x12
>  [<ffffffff8020bba3>] ? restore_args+0x0/0x30
>  [<ffffffff805e06c0>] ? kernel_init+0x0/0x340
>  [<ffffffff8020c4ae>] ? child_rip+0x0/0x12

I'm getting exactly the same backtrace (it's also a Intel Core 2 machine)
