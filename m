Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1754544AbYLQQBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbYLQQBW (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 11:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbYLQQBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 11:01:07 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53724 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbYLQQBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 11:01:06 -0500
Message-ID: <49492210.1070007@redhat.com>
Date: Wed, 17 Dec 2008 11:00:16 -0500
From: William Cohen <wcohen@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "David S. Miller" <davem@davemloft.net>,
        Robert Richter <robert.richter@amd.com>,
        Eric Dumazet <dada1@cosmosbay.com>,
        Stephane Eranian <eranian@googlemail.com>,
        Paul Mackerras <paulus@samba.org>, Peter Anvin <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        perfctr-devel@lists.sourceforge.net,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [Perfctr-devel] [patch] Performance Counters for Linux, v4
References: <20081214212829.GA9435@elte.hu>
In-Reply-To: <20081214212829.GA9435@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> We are pleased to announce the v4 release of our performance counters 
> subsystem implementation. The kernel changes can be picked up from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perfcounters/core
> 
>   (also in the master branch. There's also a kernel patch attached 
>    below.)

Machines that support virtualization are becoming very common.  How is
this performance monitoring support going to work with virtualization
(e.g. KVM)? Having the performance counters only work on physical
machines would be pretty limiting.

-Will
