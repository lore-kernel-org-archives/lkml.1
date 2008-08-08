Return-Path: <linux-kernel-owner+w=401wt.eu-S1758851AbYHHSiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851AbYHHSiz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 14:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbYHHSir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 14:38:47 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:41647 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569AbYHHSiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 14:38:46 -0400
Date: Fri, 8 Aug 2008 21:37:11 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Mark McLoughlin <markmc@redhat.com>, xen-devel@lists.xensource.com,
       Eduardo Habkost <ehabkost@redhat.com>, Stephen Tweedie <sct@redhat.com>,
       linux-kernel@vger.kernel.org, Simon Horman <horms@verge.net.au>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [Xen-devel] Re: Allow compile with CONFIG_DEBUG_INFO=y,
	X86_PAE not set on gcc 3.4.5
Message-ID: <20080808183711.GA14495@cs181140183.pp.htv.fi>
References: <20080808050429.GA8473@verge.net.au> <489BE9C3.2010006@goop.org> <20080808080155.GA1992@cs181140183.pp.htv.fi> <489C6485.7050009@goop.org> <20080808161331.GF14495@cs181140183.pp.htv.fi> <489C89FA.5000301@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <489C89FA.5000301@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 11:01:30AM -0700, Jeremy Fitzhardinge wrote:
> Adrian Bunk wrote:
>> On Fri, Aug 08, 2008 at 08:21:41AM -0700, Jeremy Fitzhardinge wrote:
>>   
>>> Adrian Bunk wrote:
>>>     
>>>> CONFIG_DEBUG_INFO=y is why I never hit it before.
>>>>
>>>> It does not seem to be just one dodgy Redhat compiler (as I assumed 
>>>> in  the Bugzilla entry) but the whole 3.4 series of gcc which makes 
>>>> our  resolution of saying that this specific compiler is broken 
>>>> invalid.
>>>>
>>>> Considering that we officially support all compilers >= 3.2 this is 
>>>> just one more case where we have to add to the kernel a workaround 
>>>> for a broken compiler.
>>>>         
>>> Yes.  I'm happy to write off a specific rpm package, but a whole 
>>> series  is a different matter.
>>>
>>> Adding
>>>
>>> 	if (PREALLOCATED_PMDS == 0)
>>> 		return;
>>>
>>> in the appropriate places with a small comment seems like the right answer.
>>>     
>>
>> The patch below you suggested fixes it for me with gcc 3.4.6.
>>
>>   
>>>    J
>>>     
>>
>> cu
>> Adrian
>>   
>
> OK.  Want to submit this as a proper patch?
>...

No, it's your patch.  :-)

> Thanks,
>    J
>...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

