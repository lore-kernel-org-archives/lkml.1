Return-Path: <linux-kernel-owner+w=401wt.eu-S1759432AbZDHO1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759432AbZDHO1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759001AbZDHO1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:27:12 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:52233 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753552AbZDHO1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:27:11 -0400
X-Sasl-enc: F+Y+A52dzrdCG++LyNfuThsRrxEwu4waWdUpUm2TI8ws 1239200829
Message-ID: <49DCB43A.8080901@fastmail.fm>
Date: Wed, 08 Apr 2009 15:27:06 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: wharms@bfs.de
CC: Bert Wesarg <bert.wesarg@googlemail.com>, linux-kernel@vger.kernel.org,
       jeff@garzik.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 20/56] inflate: Remove void casts
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-13-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-14-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-15-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-16-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-17-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-18-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-19-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-20-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-21-git-send-email-jwjstone@fastmail.fm> <36ca99e90904080439u7098d2feka5dd39f8ab6a470c@mail.gmail.com> <49DCB26C.3070709@bfs.de>
In-Reply-To: <49DCB26C.3070709@bfs.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

walter harms wrote:
> Bert Wesarg schrieb:
>   
>> On Wed, Apr 8, 2009 at 13:21, Jack Stone <jwjstone@fastmail.fm> wrote:
>>     
>>> Remove uneeded void casts
>>>
>>> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
>>> ---
>>>  lib/inflate.c |    4 ++--
>>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/lib/inflate.c b/lib/inflate.c
>>> index 1a8e8a9..4b672f9 100644
>>> --- a/lib/inflate.c
>>> +++ b/lib/inflate.c
>>> @@ -481,7 +481,7 @@ DEBG1("3 ");
>>>         z = 1 << j;             /* table entries for j-bit table */
>>>
>>>         /* allocate and link in new table */
>>> -        if ((q = (struct huft *)malloc((z + 1)*sizeof(struct huft))) ==
>>> +        if ((q = malloc((z + 1)*sizeof(struct huft))) ==
>>>             (struct huft *)NULL)
>>>       
> and move the q= from the if. less than half the size.
>
> q = malloc( (z + 1)*sizeof(*q) ):
> if ( q == NULL )
>   
I was avoiding that sort of thing as this patch series is large enough
as it is.

Thanks,

Jack
