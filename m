Return-Path: <linux-kernel-owner+w=401wt.eu-S1756306AbZBTDG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306AbZBTDG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 22:06:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbZBTDGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 22:06:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:58441 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbZBTDGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 22:06:20 -0500
Message-ID: <499E1DCF.7090005@kernel.org>
Date: Fri, 20 Feb 2009 12:04:47 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, mingo@elte.hu
Subject: Re: [PATCH 09/10] percpu: implement new dynamic percpu allocator
References: <1234958676-27618-1-git-send-email-tj@kernel.org> <1234958676-27618-10-git-send-email-tj@kernel.org> <200902192336.02800.nickpiggin@yahoo.com.au>
In-Reply-To: <200902192336.02800.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 20 Feb 2009 03:04:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Nick.

Nick Piggin wrote:
> On Wednesday 18 February 2009 23:04:35 Tejun Heo wrote:
>> Impact: new scalable dynamic percpu allocator which allows dynamic
>>         percpu areas to be accessed the same way as static ones
>>
>> Implement scalable dynamic percpu allocator which can be used for both
>> static and dynamic percpu areas.  This will allow static and dynamic
>> areas to share faster direct access methods.  This feature is optional
>> and enabled only when CONFIG_HAVE_DYNAMIC_PER_CPU_AREA is defined by
>> arch.  Please read comment on top of mm/percpu.c for details.
> 
> Seems pretty nice. Wishlist: would be cool to have per-cpu virtual
> memory mappings and do CPU-local percpu access via a single pointer.
> Of course there would need to be some machinery and maybe a new API
> to be more careful about accessing remote percpu data (that access
> could perhaps just be slower and go via the linear mapping).

Yeah, that's what's scheduled next.  Direct percpu accessors and
probably consolidation of local_t into percpu accessors.  Once dust
around the allocator itself settles down, I'll work on those.

Thanks.

-- 
tejun
