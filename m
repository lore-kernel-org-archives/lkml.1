Return-Path: <linux-kernel-owner+w=401wt.eu-S933473AbXHJMEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933473AbXHJMEn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 08:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756806AbXHJMEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 08:04:35 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:29937 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799AbXHJMEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 08:04:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tX2L+3TJwbWEJYCxGsSjmt3WvM9ITrahnF4mnH8M1euZAqp26nUtlXGLJK54lTgZ0TUmoKxJfFVe6Dwi/KJWKgYz0C2a5tqC77vEgeJL92gAEYpS4JsCe3/6/HQpHC0Md+7J81olnulaE3eHvyqaDA8f5ZEdImHBWBHQLwyazSw=
Message-ID: <6bffcb0e0708100504n7fbafb5bt6a35165277dc767a@mail.gmail.com>
Date: Fri, 10 Aug 2007 14:04:33 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Paolo Ornati" <ornati@fastwebnet.it>
Subject: Re: WARNING: at arch/x86_64/kernel/smp.c:379 smp_call_function_single()
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Avi Kivity" <avi@qumranet.com>, kvm-devel@lists.sourceforge.net
In-Reply-To: <20070810134140.2806b587@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070810134140.2806b587@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/08/07, Paolo Ornati <ornati@fastwebnet.it> wrote:
> Just got this warning during suspend2ram (2.6.23-rc2-gac078602).
>
> Config and full dmesg attached.
>
>
> [  756.707601] Disabling non-boot CPUs ...
> [  756.712034] kvm: disabling virtualization on CPU1
> [  756.712037] WARNING: at arch/x86_64/kernel/smp.c:379 smp_call_function_single()
> [  756.712039]
> [  756.712039] Call Trace:
> [  756.712046]  [<ffffffff8021d159>] smp_call_function_single+0x119/0x120
> [  756.712050]  [<ffffffff80542169>] thread_return+0x1bf/0x626
> [  756.712054]  [<ffffffff80234b5b>] sys_sched_yield+0x2b/0x80
> [  756.712057]  [<ffffffff8043684b>] kvm_cpu_hotplug+0x4b/0xa0
> [  756.712060]  [<ffffffff80247c83>] notifier_call_chain+0x53/0x80
> [  756.712062]  [<ffffffff80247d09>] __raw_notifier_call_chain+0x9/0x10
> [  756.712065]  [<ffffffff80247d21>] raw_notifier_call_chain+0x11/0x20
> [  756.712068]  [<ffffffff8026184b>] take_cpu_down+0x1b/0x30
> [  756.712071]  [<ffffffff802699d2>] do_stop+0xd2/0x150
> [  756.712073]  [<ffffffff80269900>] do_stop+0x0/0x150
> [  756.712076]  [<ffffffff8024f84d>] kthread+0x4d/0x80
> [  756.712079]  [<ffffffff8020cb28>] child_rip+0xa/0x12
> [  756.712081]  [<ffffffff8020c23c>] restore_args+0x0/0x30
> [  756.712084]  [<ffffffff8024f800>] kthread+0x0/0x80
> [  756.712086]  [<ffffffff8020cb1e>] child_rip+0x0/0x12
> [  756.712087]
> [  756.815693] CPU 1 is now offline
> [  756.815697] lockdep: not fixing up alternatives.
> [  756.819276] CPU1 is down
>

Added to KR list, thanks for the report.

Regrads,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
