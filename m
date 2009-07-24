Return-Path: <linux-kernel-owner+w=401wt.eu-S1753223AbZGXPs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbZGXPs0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 11:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbZGXPs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 11:48:26 -0400
Received: from smtp.nokia.com ([192.100.122.233]:37187 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbZGXPsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 11:48:25 -0400
Message-ID: <4A69D79F.7020105@gmail.com>
Date: Fri, 24 Jul 2009 18:47:43 +0300
From: Artem Bityutskiy <dedekind1@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Daniel Mack <daniel@caiaq.de>
CC: Adrian Hunter <adrian.hunter@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       "Bityutskiy Artem (Nokia-M/Helsinki)" <Artem.Bityutskiy@nokia.com>
Subject: Re: ubifs: error unwinding trouble
References: <20090724103038.GN19257@buzzloop.caiaq.de> <4A6991A5.4020105@nokia.com> <1248437866.24676.79.camel@localhost> <20090724154600.GR19257@buzzloop.caiaq.de>
In-Reply-To: <20090724154600.GR19257@buzzloop.caiaq.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 24 Jul 2009 15:48:12.0231 (UTC) FILETIME=[2655C570:01CA0C76]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2009 06:46 PM, Daniel Mack wrote:
> On Fri, Jul 24, 2009 at 03:17:46PM +0300, Artem Bityutskiy wrote:
>> On Fri, 2009-07-24 at 13:49 +0300, Adrian Hunter wrote:
>>> diff --git a/drivers/mtd/ubi/eba.c b/drivers/mtd/ubi/eba.c
>>> index 0f2034c..e4d9ef0 100644
>>> --- a/drivers/mtd/ubi/eba.c
>>> +++ b/drivers/mtd/ubi/eba.c
>>> @@ -1254,6 +1254,7 @@ out_free:
>>>                  if (!ubi->volumes[i])
>>>                          continue;
>>>                  kfree(ubi->volumes[i]->eba_tbl);
>>> +               ubi->volumes[i]->eba_tbl = NULL;
>>>          }
>>>          return err;
>>>   }
>> You are right. I've just pushed your patch to ubi-2.6.git/master.
>
> Great. Thanks for the quick response!
> Is there any merge cycle outstanding for ubifs in 2.6.31?

It is UBI, not UBIFS. I've created ubi-2.6.git/for-linus branch
with the stuff to merge for 2.6.31.

But I anyway always encouredge people to use the linux-next stuff
which has the latest UBI/UBIFS changes.

See http://www.linux-mtd.infradead.org/doc/ubifs.html#L_source

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
