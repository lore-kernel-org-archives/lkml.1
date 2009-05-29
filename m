Return-Path: <linux-kernel-owner+w=401wt.eu-S1756677AbZE2JrC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677AbZE2JrC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 05:47:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbZE2Jqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 05:46:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:34268 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893AbZE2Jqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 05:46:53 -0400
Message-ID: <4A1FAEE2.1020906@kernel.org>
Date: Fri, 29 May 2009 18:46:10 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Christoph Hellwig <hch@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <dada1@cosmosbay.com>, davem@davemloft.net
Subject: Re: [my_cpu_ptr 1/5] Introduce my_cpu_ptr()
References: <20090527180635.008102701@gentwo.org> <20090527180714.834691580@gentwo.org> <200905281316.01923.rusty@rustcorp.com.au> <20090528161028.GA20190@infradead.org> <alpine.DEB.1.10.0905281236490.17705@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0905281236490.17705@gentwo.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 29 May 2009 09:46:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Thu, 28 May 2009, Christoph Hellwig wrote:
> 
>> On Thu, May 28, 2009 at 01:16:01PM +0930, Rusty Russell wrote:
>>> On Thu, 28 May 2009 03:16:59 am cl@linux-foundation.org wrote:
>>>> my_cpu_ptr(xx) = per_cpu_ptr(xx, smp_processor_id).
>>> I had this implemented earlier as as get_cpu_ptr()/__get_cpu_ptr(), to match
>>> get_cpu_var() / __get_cpu_var().
>>>
>>> But other than that nomenclature quibble, it looks fine!
>> my_ seems a very odd naming.  We have a lot of this_cpu naming for the
>> current cpu i nthe ctree, so I would suggest sticking to that.
> 
> So this_cpu is taken. I used THIS_CPU in earlier version
> but got complaints about uppercase use. Is
> 
> this_cpu_ptr()
> 
> and
> 
> __this_cpu_ptr()
> 
> ok?

Yeap, those look fine to me.  Sans the renaming, the series generally
looks good but I didn't review each conversion.

For the first patch, Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
