Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab0CEHPL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 02:15:11 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46185 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682Ab0CEHPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 02:15:09 -0500
Message-ID: <4B90AFF3.3030100@pathscale.com>
Date: Fri, 05 Mar 2010 14:17:07 +0700
From: =?ISO-8859-1?Q?=22C=2E_Bergstr=F6m=22?= <cbergstrom@pathscale.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090909)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Ingo Molnar <mingo@elte.hu>, Ben Skeggs <skeggsb@gmail.com>,
       Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>, dri-devel@lists.sf.net,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull] drm request 3
References: <20100304103655.0b14343f@jbarnes-piketon>	<alpine.LFD.2.00.1003041047400.3751@localhost.localdomain>	<20100304105624.70fe845e@jbarnes-piketon>	<alpine.LFD.2.00.1003041101390.3751@localhost.localdomain>	<21d7e9971003041125x1aee3b3ew1e407ca6695e10fc@mail.gmail.com>	<alpine.LFD.2.00.1003041142250.3751@localhost.localdomain>	<21d7e9971003041406n53d9cae0h53374abf3dca494e@mail.gmail.com>	<alpine.LFD.2.00.1003041554490.3751@localhost.localdomain>	<1267748927.3496.6.camel@nisroch> <20100305064955.GA6453@elte.hu> <84144f021003042306w2e017efbva2be364c1c4980a7@mail.gmail.com>
In-Reply-To: <84144f021003042306w2e017efbva2be364c1c4980a7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> On Fri, Mar 5, 2010 at 8:49 AM, Ingo Molnar <mingo@elte.hu> wrote:
>   
>> The conclusion is crystal clear, breaking an ABI via a "flag day"
>> cleanup/feature/etc is:
>>
>>  - wrong
>>
>>  - harmful
>>
>>  - limits the developer base
>>
>>  - limits the tester base
>>
>>  - wastes time and effort. (fewer developers/testers means that while _this_
>>   feature was easier to add, all your _future_ features will be a bit harder
>>   to do. It compounds up.)
>>
>>  - so it hurts even the very developer who is most convinced that this was the
>>   right thing to do
>>
>> It's a bad technical decision throughout. It's masochistic and often suicidal
>> to just about any project in essence. I've seen projects that did it once and
>> died just due to that single act of stupidity. I've seen projects that have
>> done it a few times and took the usage hit, limped along with the wounds and
>> never grew to the size they could have achieved. I've seen projects that did
>> it once, took the hit, learned from it and never did it again.
>>     
>
> Agreed. What bothers me in this discussion is that people keep
> bringing up the fact that nouveau is mostly developed by volunteers
> and thus it doesn't make sense to make sure it's backwards (or
> forwards) compatible. But the way I see it, it's the complete
> opposite. It's _more_ important to support ABIs for community-driven
> efforts because you're relying on people who by definition don't have
> time to waste. While the nouveau people might have good intentions,
> I'm afraid they might be severely limiting their developer and tester
> base because they're not focused on real world problems (like the ones
> Linus is seeing).
staging != stable

Nobody guaranteed a stable API for staging and in fact it was stated 
previously it needed to be changed.  Please lets just get back to work 
and stop declaring the sky is falling.
