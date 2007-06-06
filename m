Return-Path: <linux-kernel-owner+w=401wt.eu-S965065AbXFFXQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965065AbXFFXQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 19:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935862AbXFFXPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 19:15:55 -0400
Received: from lucidpixels.com ([75.144.35.66]:43184 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935874AbXFFXPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 19:15:54 -0400
Date: Wed, 6 Jun 2007 19:15:53 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Jesse Barnes <jesse.barnes@intel.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
In-Reply-To: <20070606161103.f8e3b253.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0706061915090.2716@p34.internal.lan>
References: <200706061229.24486.jesse.barnes@intel.com>
 <200706061524.52628.jesse.barnes@intel.com> <Pine.LNX.4.64.0706061826260.5415@p34.internal.lan>
 <200706061528.44070.jesse.barnes@intel.com> <20070606153737.2c9da784.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0706061852590.2716@p34.internal.lan>
 <20070606161103.f8e3b253.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 6 Jun 2007, Randy Dunlap wrote:

> On Wed, 6 Jun 2007 18:54:37 -0400 (EDT) Justin Piszcz wrote:
>
>> Hm, not sure if it was from the patch or what but I ran this:
>>
>> 1. swapoff -a
>> 2. ./eatmem
>>
>
> You usually have to access the allocated memory, like:
>
> 	*d = 1.0;
>
> for it to actually be allocated (AFAIK).
>
>>    }
>>
>>    return 0;
>> }
>>
>> Any idea why the OOM killer can or does not kill it?
>
> What are the values of /proc/sys/vm/overcommit* ?
>
> See Documentation/vm/overcommit-accounting .

They should be the defaults as I do not change them:

p34:~# find /proc/|grep -i overcommit
/proc/sys/vm/overcommit_memory
/proc/sys/vm/overcommit_ratio
find: /proc/5128: No such file or directory
p34:~# cat /proc/sys/vm/overcommit_memory
0
p34:~# cat /proc/sys/vm/overcommit_ratio
50
p34:~#


Comments?
