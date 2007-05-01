Return-Path: <linux-kernel-owner+w=401wt.eu-S1031205AbXEAMlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031205AbXEAMlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 08:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031680AbXEAMlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 08:41:42 -0400
Received: from [38.97.70.124] ([38.97.70.124]:55984 "EHLO
	cirdan.nrcc.noklab.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1031205AbXEAMlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 08:41:40 -0400
X-Greylist: delayed 1365 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 May 2007 08:41:40 EDT
Message-ID: <463730B5.20206@handhelds.org>
Date: Tue, 01 May 2007 08:21:09 -0400
From: Jamey Hicks <jamey@handhelds.org>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Paul Sokolovsky <pmiscml@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kernel-discuss@handhelds.org
Subject: Re: [RFC, PATCH 2/4] SoC base drivers: ASIC3 SoC hardware definitions
References: <516386418.20070501080839@gmail.com> <20070430235642.e576e917.akpm@linux-foundation.org> <20070501112751.6b1d9452@the-village.bc.nu> <1173924397.20070501150418@gmail.com>
In-Reply-To: <1173924397.20070501150418@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Sokolovsky wrote:
> Hello Alan,
>
> Tuesday, May 1, 2007, 1:27:51 PM, you wrote:
>
>   
>>>> + * Copyright 2001 Compaq Computer Corporation.
>>>> + *
>>>> + * Use consistent with the GNU GPL is permitted,
>>>> + * provided that this copyright notice is
>>>> + * preserved in its entirety in all copies and derived works.
>>>> + *
>>>> + * COMPAQ COMPUTER CORPORATION MAKES NO WARRANTIES, EXPRESSED OR IMPLIED,
>>>> + * AS TO THE USEFULNESS OR CORRECTNESS OF THIS CODE OR ITS
>>>> + * FITNESS FOR ANY PARTICULAR PURPOSE.
>>>>         
>
>   
>> This doesn't appear to be self consistent or GPL compatible. Any binary
>> will be a derivative work and will not contain the copyright notice.
>>     
>
>         Well, this is one of those hard questions... Fortunately,
> people who worked on this and were Compaq employees are reachable, so
> I contacted Jamie Hicks, who is one of the authors of iPaq ports,
> regarding solution for this. Jamie, would it be possible to leave
> Compaq and other copyright notices, and Compaq disclaimer intact,
> but replace following paragraph:
>
>   
>> + * Use consistent with the GNU GPL is permitted,
>> + * provided that this copyright notice is
>> + * preserved in its entirety in all copies and derived works.
>>     
>
>         With more common wording as appears in kernel sources:
>
>   
>>   This program is free software; you can redistribute it and/or modify
>>   it under the terms of the GNU General Public License as published by
>>   the Free Software Foundation; either version 2 of the License, or
>>   (at your option) any later version.
>>     
>
> (or GPL2 wording, or verbose wording, whatever you see fit)
>
> Thanks!
>   
The intent of the vague wording was to have the copyright notice and 
Compaq disclaimer of warranties preserved in the source code, not in 
binaries, but it is definitely ambiguous. As I understand it, copyright 
law says the copyright notices need to be preserved in source code, so 
that part of the statement is redundant, and GPL has its own warrantee 
disclaimer, so I think the standard wording is just fine. I approve 
changing to the more standard GPL wording used in the kernel sources in 
order to make this acceptable into the kernel.org tree.

Jamey Hicks

