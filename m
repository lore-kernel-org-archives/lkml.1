Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574AbYJWFgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbYJWFgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 01:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbYJWFgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 01:36:41 -0400
Received: from ozlabs.org ([203.10.76.45]:43833 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925AbYJWFgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 01:36:41 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 35/35] x86: clean up speedctep-centrino and reduce cpumask_t usage From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 23 Oct 2008 16:36:30 +1100
User-Agent: KMail/1.9.10
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20081023020826.051012000@polaris-admin.engr.sgi.com> <20081023020833.302361000@polaris-admin.engr.sgi.com>
In-Reply-To: <20081023020833.302361000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810231636.30722.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 October 2008 13:09:01 Mike Travis wrote:
> 1) The #ifdef CONFIG_HOTPLUG_CPU seems unnecessary these days.
> 2) The loop can simply skip over offline cpus, rather than creating a tmp
> mask.
> 3) set_mask is set to either a single cpu or all online cpus in a 
> policy. Since it's just used for set_cpus_allowed(), any offline cpus in a
> policy don't matter, so we can just use cpumask_of_cpu() or the
> policy->cpus.

Note that this cleanup stands alone; it's just that I read this code I 
couldn't help but tidy it up.

Ingo: do you just want to put this in your normal tree for sending to Linus?

Thanks,
Rusty.
