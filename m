Return-Path: <linux-kernel-owner+w=401wt.eu-S1760122AbXJZRCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760122AbXJZRCZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 13:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169AbXJZRCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 13:02:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34423 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbXJZRCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 13:02:00 -0400
Message-ID: <47221D6D.3000807@zytor.com>
Date: Fri, 26 Oct 2007 10:01:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: =?ISO-8859-1?Q?Simon_Holm_Th=F8gersen?= <odie@cs.aau.dk>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] raid6: generate raid6tables.c with proper style
References: <20071026081752.GA1232@elte.hu> <1193397991.7078.5.camel@odie.local> <20071026152257.GB26619@elte.hu>
In-Reply-To: <20071026152257.GB26619@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Simon Holm Thøgersen <odie@cs.aau.dk> wrote:
> 
>> fre, 26 10 2007 kl. 10:17 +0200, skrev Ingo Molnar:
>>> Subject: raid6: generate raid6tables.c with proper style
>>> From: Ingo Molnar <mingo@elte.hu>
>> [snip]
>>
>>> Index: linux/drivers/md/mktables.c
>>> ===================================================================
>>> --- linux.orig/drivers/md/mktables.c
>>> +++ linux/drivers/md/mktables.c
>>> @@ -69,7 +69,9 @@ int main(int argc, char *argv[])
>>>      for ( j = 0 ; j < 256 ; j += 8 ) {
>>>        printf("\t\t");
>>>        for ( k = 0 ; k < 8 ; k++ ) {
>>> -	printf("0x%02x, ", gfmul(i,j+k));
>>> +        if (k)
>>> +	  printf(" ");
>>> +	printf("0x%02x,", gfmul(i,j+k));
>> What happened with the coding style here?
> 
> i adopted to the existing (broken) one. Yes, mktables.c could need a 
> good cleanup too.
> 

More so than the output, IMNSHO.  I'll take care of it.

	-hpa
