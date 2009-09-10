Return-Path: <linux-kernel-owner+w=401wt.eu-S1753607AbZIJFiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbZIJFiI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 01:38:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbZIJFiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 01:38:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34490 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbZIJFiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 01:38:07 -0400
Message-ID: <4AA88FAB.2090002@zytor.com>
Date: Wed, 09 Sep 2009 22:33:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH RFC] char/tty_io: fix legacy pty name when more than 256
 pty devices are requested
References: <20090908144942.76ddf0e7@caramujo.chehab.org>	<4AA6DF50.3030603@zytor.com>	<20090908203323.486c129c@caramujo.chehab.org>	<4AA6F63F.7090009@zytor.com>	<20090908235441.04549a29@caramujo.chehab.org>	<4AA73309.8030302@zytor.com> <20090910011320.3a6ec797@caramujo.chehab.org>
In-Reply-To: <20090910011320.3a6ec797@caramujo.chehab.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2009 09:13 PM, Mauro Carvalho Chehab wrote:
> Em Tue, 08 Sep 2009 21:46:01 -0700
> "H. Peter Anvin" <hpa@zytor.com> escreveu:
> 
>> Actually it's [7:4][*:8][3:0].  It was the easiest way to get backwards
>> compatibility, since it allowed for the use of s[n]printf().  It's not
>> by any means the only possibility, but I think the easiest one to describe.
>>
>>> From one side, I liked the idea of not having any arbitrary maximum limit, but
>>> from other side, It seems easier to implement than to describe it in English,
>>> at devices.txt. Maybe the solution is to explain it by examples.
>>>
>>> Also, if we look at the current device designation, we already have some rule
>>> changes. 
>>
>> That doesn't mean it's a good idea.
> 
> True. Given the idea of using an unique algorithm to populate the namespace, I agree
> that your proposal is a good alternative.
> 
> I just sent the patch with the feedbacks I had. I tried to do my best to describe it in
> simple yet precise terms at devices.txt.
> 

Looks good, except:

	s/nibble/nybble/

"nybble" is to "nibble" what "byte" is to "bite".

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

