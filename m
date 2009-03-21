Return-Path: <linux-kernel-owner+w=401wt.eu-S1757740AbZCUMcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757740AbZCUMcT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 08:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbZCUMcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 08:32:01 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:38574 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbZCUMcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 08:32:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=tCwGLMKnEQDoPlE/YB6ZVhKcWXv4mDPqwS9ezb4wvZU00s9jHwyqIU9PIjHgocRwHi
         zxbbLQE9oK1G20yhEzCusZCl2GBaaCaBkVFq64i1H/g5zCvhoxliJtCtQTToKjcHfQYj
         +HijQJs5PMICXSQELjPeN2kpNSoNB+IuGDqAw=
Message-ID: <49C4DE2C.8010808@vflare.org>
Date: Sat, 21 Mar 2009 18:01:40 +0530
From: Nitin Gupta <nitingupta910@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] compcache documentation
References: <49C3A31D.6070208@vflare.org>	<49C3A4B0.3050503@vflare.org> <20090321032636.fdeae224.akpm@linux-foundation.org>
In-Reply-To: <20090321032636.fdeae224.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 20 Mar 2009 19:44:08 +0530 Nitin Gupta <ngupta@vflare.org> wrote:
> 
>> ...
>>
>> +   backing_dev: This is block device to be used as backing store for compcache.
>> +	It must be a valid swap partition. We move data to this device when we
>> +	encounter incompressible page or memlimit is reached. TODO: we may also
>> +	move some pages from compcache to this device in case system is really
>> +	low on memory.
>> +	This device is not directly visible to kernel as a swap device
>> +	(/proc/swaps will only show /dev/ramzswap0 and not this device).
>> +	Managing this backing device is the job of compcache module.
> 
> hrm, OK, it kinda/sorta/maybe might be a little bit like a "compressed
> cache".  But if someone comes up with a real compressed cache (ie:
> pagecache) then they'll want their name back.
> 
Rename is in progress: compcache->ramzswap :)

> Also, the kernel already has a widespread and well-established "backing
> device" concept, in include/linux/backing-dev.h.  This new feature's
> poaching of that identifier is a bit confusing.  It would be nice to do a
> wholesale rename if possible.  secondary_dev?  nv_dev?
> 

backing_swap?

Thanks,
Nitin
