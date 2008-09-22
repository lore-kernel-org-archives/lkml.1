Return-Path: <linux-kernel-owner+w=401wt.eu-S1753650AbYIVOru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650AbYIVOru (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 10:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbYIVOrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 10:47:40 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55833 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752555AbYIVOrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 10:47:39 -0400
Message-ID: <48D7B009.7090700@sgi.com>
Date: Mon, 22 Sep 2008 07:47:37 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, rpurdie@rpsys.net,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/1] SGI X86 UV: Provide a System Activity Indicator	driver
References: <20080919143744.009764000@polaris-admin.engr.sgi.com> <20080919143744.190005000@polaris-admin.engr.sgi.com> <20080922114820.GA13990@elte.hu>
In-Reply-To: <20080922114820.GA13990@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>>  arch/x86/kernel/genx2apic_uv_x.c |  138 +++++++++++++++++++++++++++++++++++++++
>>  include/asm-x86/uv/uv_hub.h      |   62 +++++++++++++++++
> 
> hm, why is this in genx2apic_uv_x.c, not a separate file?

This keeps it in the uv_hub percpu area, a chunk of memory that is accessed
quite often for many of the basic UV operations.  This should increase the
probability that the data is already located in the cpu's cache.

Thanks,
Mike

