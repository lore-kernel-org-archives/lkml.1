Return-Path: <linux-kernel-owner+w=401wt.eu-S1754115AbYI3Sro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbYI3Sro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 14:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbYI3SrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 14:47:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55191 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbYI3SrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 14:47:22 -0400
Message-ID: <48E27425.7010705@zytor.com>
Date: Tue, 30 Sep 2008 11:47:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: =?UTF-8?B?IkouQS4gTWFnYWxsw7NuIg==?= <jamagallon@ono.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: Typo bug [Re: Linux 2.6.27-rc8]
References: <alpine.LFD.2.00.0809291527460.3389@nehalem.linux-foundation.org> <20080930094346.307ef1e5@werewolf.home> <20080930075553.GB20241@elte.hu>
In-Reply-To: <20080930075553.GB20241@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> early_param("enble_mtrr_cleanup", enable_mtrr_cleanup_setup);
>>              ^^^^^^
>>
>> Nice ;)
> 
> heh. Could you send a patch with a changelog please?

These options are also named inconsistently with all other options.

The standard way to name an boolean option is "foo" versus "nofoo", in 
this case, "mtrrcleanup" vs "nomtrrcleanup".

	-hpa
