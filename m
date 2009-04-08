Return-Path: <linux-kernel-owner+w=401wt.eu-S1763579AbZDHTL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763579AbZDHTL1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 15:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbZDHTLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 15:11:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:53625 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666AbZDHTLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 15:11:15 -0400
Message-ID: <49DCF6A6.4070909@kernel.org>
Date: Wed, 08 Apr 2009 12:10:30 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/apic] x86: make wakeup_secondary_cpu_via_init static
References: <49D6A692.6040400@kernel.org> <tip-cdc1cb0d4445f39561a65204d26f89365f917550@git.kernel.org> <20090408183924.GF7556@lenovo>
In-Reply-To: <20090408183924.GF7556@lenovo>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> [Yinghai Lu - Wed, Apr 08, 2009 at 01:00:32PM +0000]
> | Commit-ID:  cdc1cb0d4445f39561a65204d26f89365f917550
> | Gitweb:     http://git.kernel.org/tip/cdc1cb0d4445f39561a65204d26f89365f917550
> | Author:     Yinghai Lu <yinghai@kernel.org>
> | AuthorDate: Fri, 3 Apr 2009 17:15:14 -0700
> | Committer:  Ingo Molnar <mingo@elte.hu>
> | CommitDate: Wed, 8 Apr 2009 14:50:28 +0200
> | 
> | x86: make wakeup_secondary_cpu_via_init static
> | 
> | Impact: cleanup
> | 
> | Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> | LKML-Reference: <49D6A692.6040400@kernel.org>
> | Signed-off-by: Ingo Molnar <mingo@elte.hu>
> | 
> | 
> | ---
> |  arch/x86/kernel/smpboot.c |    2 +-
> |  1 files changed, 1 insertions(+), 1 deletions(-)
> | 
> | diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> | index 58d24ef..bddf2cc 100644
> | --- a/arch/x86/kernel/smpboot.c
> | +++ b/arch/x86/kernel/smpboot.c
> | @@ -538,7 +538,7 @@ wakeup_secondary_cpu_via_nmi(int logical_apicid, unsigned long start_eip)
> |  	return (send_status | accept_status);
> |  }
> |  
> | -int __devinit
> | +static int __devinit
> |  wakeup_secondary_cpu_via_init(int phys_apicid, unsigned long start_eip)
> |  {
> |  	unsigned long send_status, accept_status = 0;
> 
> Hi Yinghai,
> 
> just curious why it's not __cpuinit? Did I miss something?
> 

you could change that to __cpuinit.

also other three wakeup_seconary_cpu.

YH
