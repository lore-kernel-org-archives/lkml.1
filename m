Return-Path: <linux-kernel-owner+w=401wt.eu-S1762347AbZDIVow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762347AbZDIVow (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 17:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757482AbZDIVol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 17:44:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:55301 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757058AbZDIVok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 17:44:40 -0400
Message-ID: <49DE6C6F.8090402@kernel.org>
Date: Thu, 09 Apr 2009 14:45:19 -0700
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/12]: sparc64: Use new dynamic per-cpu allocator.
References: <20090408.223758.81953207.davem@davemloft.net>	<49DDE07C.8050101@kernel.org> <20090409.142923.252620650.davem@davemloft.net>
In-Reply-To: <20090409.142923.252620650.davem@davemloft.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 09 Apr 2009 21:44:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
>> Isn't it better to use embedding allocator for !NUMA cases (one less
>> TLB entry usage for each CPU)?
> 
> Heck, the embedding case would probably be optimal for Niagara NUMA
> systems too.
> 
> On Niagara systems all of the "possible" cpu numbers are linear and in
> order.  No holes, gaps, or other stuff like this.  So just allocating
> big TLB mapping chunks and chopping them up to the individual cpus is
> the best scheme possible.

Sounds great.  I wonder whether the remap allocator could be replaced
with embed allocator with right parameters on x86 too.

Thanks.

-- 
tejun
