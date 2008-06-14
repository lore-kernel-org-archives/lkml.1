Return-Path: <linux-kernel-owner+w=401wt.eu-S1757147AbYFNHuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147AbYFNHuB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 03:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbYFNHtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 03:49:52 -0400
Received: from stinky.trash.net ([213.144.137.162]:63844 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbYFNHtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 03:49:51 -0400
Message-ID: <485375A1.5000805@trash.net>
Date: Sat, 14 Jun 2008 09:39:13 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Chuck Ebbert <cebbert@redhat.com>, x86@kernel.org
Subject: Re: 2.6.26-git: NULL pointer deref in __switch_to
References: <4852B19E.4010202@trash.net> <19f34abd0806131124w32133715o3ef8c27cb0a9f96e@mail.gmail.com> <20080613224711.GA15084@linux-os.sc.intel.com> <20080614062014.GA7340@elte.hu>
In-Reply-To: <20080614062014.GA7340@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
>
>   
>> Somehow (as described below?) TS_USEDFPU is set but the fpu is not 
>> allocated or freed.
>>
>> Please try the appended patch.
>>     
>
> i've queued up your fix in tip/x86/urgent. (Git access coordinates: 
> http://people.redhat.com/mingo/tip.git/README)
>
> i'm wondering why this problem was not hit more frequently. Does it need 
> some special FPU use to trigger? Or does it need an exec() with the FPU 
> stack still active? (normally the FPU stack is empty at exec() time)

I've recently started running three lguest instances on that machine,
maybe that has something to do with it.


