Return-Path: <linux-kernel-owner+w=401wt.eu-S1760153AbYDYH4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760153AbYDYH4l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 03:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbYDYH4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 03:56:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:60757 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbYDYH4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 03:56:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=TQKqr09auAahjVDEYK9b9UhirSGdCGr5Z1yb8UKcq0Dp1FNx947VHwLl+BzrHIIbt5MYbz+c1y2ANEvUm5XKK/v5/mUyPqXQj2jpeGmcRf7pF4dNojWLIls55FMAPyhK0MVBHXbeGDvyK0Kssva/MCUvS6N5vWo/QFDvcnHAlkU=
Message-ID: <48118EAB.5040004@gmail.com>
Date: Fri, 25 Apr 2008 09:56:27 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: torvalds@linux-foundation.org, zdenek.kabelac@gmail.com, mingo@elte.hu,
       rjw@sisk.pl, paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       herbert@gondor.apana.org.au, penberg@cs.helsinki.fi, clameter@sgi.com
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
References: <4811090A.9030809@gmail.com>	<20080424.183558.96469288.davem@davemloft.net>	<48118B73.6000700@gmail.com> <20080425.004943.148536408.davem@davemloft.net>
In-Reply-To: <20080425.004943.148536408.davem@davemloft.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2008 09:49 AM, David Miller wrote:
> From: Jiri Slaby <jirislaby@gmail.com>
> Date: Fri, 25 Apr 2008 09:42:43 +0200
> 
>> On 04/25/2008 03:35 AM, David Miller wrote:
>>> From: Jiri Slaby <jirislaby@gmail.com>
>>> Date: Fri, 25 Apr 2008 00:26:18 +0200
>>>
>>>> ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadccf0 
>>> 0xf0...  Is this a 4-cpu machine?
>> It's a 2 cores machine.
> 
> Two hyperthreads per-core?

Hmm, how to find out? I suppose it will show up 4 (virtual) processors in 
cpuinfo, right? Although there is ht bit in cpuinfo on each core and 
CONFIG_X86_HT=y, I don't see 4 cpus.

> If so that could match up to the pattern.  It is just one theory
> though.  The wireless possibility holds just as much weight.

The mac80211 is theory too so far :).


