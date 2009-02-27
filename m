Return-Path: <linux-kernel-owner+w=401wt.eu-S1755329AbZB0C7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbZB0C7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 21:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbZB0C7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 21:59:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:46464 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414AbZB0C7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 21:59:04 -0500
Message-ID: <49A756CF.7080309@kernel.org>
Date: Fri, 27 Feb 2009 11:58:23 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Ingo Molnar <mingo@elte.hu>, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/percpu] bootmem: clean up arch-specific bootmem wrapping
References: <tip-c132937556f56ee4b831ef4b23f1846e05fde102@kernel.org> <20090224214638.GA2049@cmpxchg.org> <20090224214932.GC12601@elte.hu> <20090224234949.GA1778@cmpxchg.org> <49A4ACAE.4020104@kernel.org> <20090225024316.GA1738@cmpxchg.org> <49A4CE93.3070908@kernel.org> <49A4CEE1.7090003@kernel.org>
In-Reply-To: <49A4CEE1.7090003@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 27 Feb 2009 02:58:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Tejun Heo wrote:
>> This patch drops the generic wrapping around alloc_bootmem_core() and
>> add alloc_bootmem_core() instead.  If necessary, arch can define
>       ^^^^^^^^^^^^^^^^^^^^
> should have been alloc_arch_preferred_bootmem()
> 
>> bootmem_arch_referred_node() macro or function which takes all
>> allocation information and returns the preferred node.  bootmem
>> generic code will always try the preferred node first and then
>> fallback to other nodes as usual.

Ping. Johannes, can you please review the patch?

Thanks.

-- 
tejun
