Return-Path: <linux-kernel-owner+w=401wt.eu-S1752286AbZCMEA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbZCMEA2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 00:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750791AbZCMEAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 00:00:14 -0400
Received: from jalapeno.cc.columbia.edu ([128.59.29.5]:42405 "EHLO
	jalapeno.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbZCMEAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 00:00:13 -0400
Message-ID: <49B9D9B9.4070508@cs.columbia.edu>
Date: Thu, 12 Mar 2009 23:57:45 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-api@vger.kernel.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>,
       linux-mm@kvack.org, viro@zeniv.linux.org.uk, hpa@zytor.com,
       mingo@elte.hu, torvalds@linux-foundation.org, tglx@linutronix.de
Subject: Re: [RFC v13][PATCH 00/14] Kernel based checkpoint/restart
References: <1233076092-8660-1-git-send-email-orenl@cs.columbia.edu>	<1234285547.30155.6.camel@nimitz>	<20090211141434.dfa1d079.akpm@linux-foundation.org>	<1234462282.30155.171.camel@nimitz>	<20090213152836.0fbbfa7d.akpm@linux-foundation.org> <49B9C8E0.5080500@cs.columbia.edu>
In-Reply-To: <49B9C8E0.5080500@cs.columbia.edu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Oren Laadan wrote:
> Hi,
> 
> Just got back from 3 weeks with practically no internet, and I see
> that I missed a big party !
> 
> Trying to catch up with what's been said so far --

[...]

>>>>
>>>> - Will any of this involve non-trivial serialisation of kernel
>>>>   objects?  If so, that's getting into the
>>>>   unacceptably-expensive-to-maintain space, I suspect.
>>> We have some structures that are certainly tied to the kernel-internal
>>> ones.  However, we are certainly *not* simply writing kernel structures
>>> to userspace.  We could do that with /dev/mem.  We are carefully pulling
>>> out the minimal bits of information from the kernel structures that we
>>> *need* to recreate the function of the structure at restart.  There is a
>>> maintenance burden here but, so far, that burden is almost entirely in
>>> checkpoint/*.c.  We intend to test this functionality thoroughly to
>>> ensure that we don't regress once we have integrated it.
>> I guess my question can be approximately simplified to: "will it end up
>> looking like openvz"?  (I don't believe that we know of any other way
>> of implementing this?)
>>
>> Because if it does then that's a concern, because my assessment when I
>> looked at that code (a number of years ago) was that having code of
>> that nature in mainline would be pretty costly to us, and rather
>> unwelcome.
> 
> I originally implemented c/r for linux as as kernel module, without
> requiring any changes from the kernel. (Doing the namespaces as a kernel
> module was much harder). For more details, see:
> 	https://www.ncl.cs.columbia.edu/research/migrate

oops... I meant the following link:
	http://www.ncl.cs.columbia.edu/research/migration/

see, for example, the papers from DejaView (SOSP 07) and Zap (USENIX 07).

Oren.


