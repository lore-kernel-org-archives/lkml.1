Return-Path: <linux-kernel-owner+w=401wt.eu-S2992917AbXDYSyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992917AbXDYSyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 14:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992927AbXDYSyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 14:54:14 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:57938 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992917AbXDYSyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 14:54:13 -0400
Message-ID: <462FA3B9.5080008@freescale.com>
Date: Wed, 25 Apr 2007 13:53:45 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.7.10) Gecko/20050909 Red Hat/1.7.10-1.1.3.2
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Vitaly Bordug <vitb@kernel.crashing.org>
CC: Olof Johansson <olof@lixom.net>, Jean Delvare <khali@linux-fr.org>,
       "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC][POWERPC] i2c: adds support for i2c bus on 8xx
References: <20070420082714.4f10f186@localhost.localdomain>	<20070423025709.GA28805@lixom.net> <462F8953.1020201@kernel.crashing.org>
In-Reply-To: <462F8953.1020201@kernel.crashing.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vitaly Bordug wrote:
> i2c && 8xx combo never work with 2.6 at least in mainstream. That's why 
> related stuff were scheduled to removal by Jean even,
> before I came up with this stuff.
[snip]
>> This could all be done with an of_platform driver instead, and avoid 
>> the above.
>> (Someone else already suggested that I believe).
>>
>>   
> 
> I know i know. But it was decided, while both ppc/ and powerpc/ wander 
> around, platform devices way is preferrable.

The idea is to avoid regressions in arch/ppc; maintaining feature parity 
isn't necessary.  If, as you say above, 8xx i2c was already broken in 
2.6 (even in arch/ppc), then I see no reason not to go to an of_device 
right away.

> It is apparent why - so far only mpc885 is alive in arch/powerpc, and it 
> is not going to change soon for 8xx. 

Actually, I plan to do some arch/powerpc 8xx work over the next couple 
months, so hopefully it will change soon. :-)

-Scott
