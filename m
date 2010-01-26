Return-Path: <linux-kernel-owner+w=401wt.eu-S1753369Ab0AZCF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab0AZCF0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 21:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276Ab0AZCFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 21:05:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:48217 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370Ab0AZCFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 21:05:23 -0500
Message-ID: <4B5E4F30.60600@kernel.org>
Date: Tue, 26 Jan 2010 11:10:56 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       axboe@kernel.dk, rusty@rustcorp.com.au, akpm@linux-foundation.org,
       ebiederm@xmission.com, tytso@mit.edu, Trond.Myklebust@netapp.com,
       aelder@sgi.com, hch@infradead.org, viro@zeniv.linux.org.uk,
       davem@davemloft.net, netdev@vger.kernel.org, x86@kernel.org,
       mingo@redhat.com, dan.j.williams@intel.com, borislav.petkov@amd.com,
       ying.huang@intel.com, lenb@kernel.org, neilb@suse.de,
       cl@linux-foundation.org
Subject: Re: [PATCH 7/8] percpu: add __percpu sparse annotations to	hw_breakpoint
References: <1264432935-10453-1-git-send-email-tj@kernel.org> <1264432935-10453-8-git-send-email-tj@kernel.org> <20100126001901.GI5087@nowhere> <4B5E401D.2020809@zytor.com>
In-Reply-To: <4B5E401D.2020809@zytor.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 26 Jan 2010 02:04:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 01/26/2010 10:06 AM, H. Peter Anvin wrote:
>> I guess __percpu is an address_space attribute? Is there no
>> way to force the address space change directly from the
>> per_cpu() macro?
>>
> 
> Hmm... thinking more about it, we should be able to just move the & and
> [0] into the per_cpu() macro, addressing the situation, or does that
> cause problems elsewhere?

Hmmm.... the argument gotta be an lvalue.  Let me try just in case.
Nope, it doesn't work.

Thanks.

-- 
tejun
