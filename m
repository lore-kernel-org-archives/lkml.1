Return-Path: <linux-kernel-owner+w=401wt.eu-S1754016AbYI3Vh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbYI3Vh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 17:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbYI3VhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 17:37:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41141 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbYI3VhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 17:37:19 -0400
Message-ID: <48E29BFE.4040309@zytor.com>
Date: Tue, 30 Sep 2008 14:37:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>,
       =?UTF-8?B?IkouQS4gTWFnYWxsw7NuIg==?= <jamagallon@ono.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Typo bug [Re: Linux 2.6.27-rc8]
References: <alpine.LFD.2.00.0809291527460.3389@nehalem.linux-foundation.org>	 <20080930094346.307ef1e5@werewolf.home>	 <20080930075553.GB20241@elte.hu> <48E27425.7010705@zytor.com>	 <86802c440809301230s7dd33e69m83dab51f915580b1@mail.gmail.com>	 <48E28528.5070605@zytor.com> <86802c440809301435r79fb2553p65130b6451e83fa4@mail.gmail.com>
In-Reply-To: <86802c440809301435r79fb2553p65130b6451e83fa4@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Tue, Sep 30, 2008 at 12:59 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Yinghai Lu wrote:
>>> On Tue, Sep 30, 2008 at 11:47 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>>> Ingo Molnar wrote:
>>>>>> early_param("enble_mtrr_cleanup", enable_mtrr_cleanup_setup);
>>>>>>            ^^^^^^
>>>>>>
>>>>>> Nice ;)
>>>>> heh. Could you send a patch with a changelog please?
>>>> These options are also named inconsistently with all other options.
>>>>
>>>> The standard way to name an boolean option is "foo" versus "nofoo", in
>>>> this
>>>> case, "mtrrcleanup" vs "nomtrrcleanup".
>>>>
>>> ok, we could change it...
>> If we're fixing a typo anyway I'd suggest so.  We know we're not breaking
>> anyone's working setup...
> 
> mtrr_cleanup and no_mtrr_cleanup?
> 

Dashes seem to be used more than underscores, so it probably should be 
"mtrr-cleanup" and "nomtrr-cleanup" if you want a separator.

	-hpa
