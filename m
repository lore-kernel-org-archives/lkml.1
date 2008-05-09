Return-Path: <linux-kernel-owner+w=401wt.eu-S934783AbYEIF6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934783AbYEIF6P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 01:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763578AbYEIF56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 01:57:58 -0400
Received: from mbox1.netikka.net ([213.250.81.202]:56269 "EHLO
	mbox1.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763474AbYEIF55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 01:57:57 -0400
Message-ID: <4823E7DE.5010104@mandriva.org>
Date: Fri, 09 May 2008 08:57:50 +0300
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080305)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: "gene.heskett@gmail.com" <gene.heskett@gmail.com>,
       "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "mchehab@infradead.org" <mchehab@infradead.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-dvb-maintainer@linuxtv.org" <linux-dvb-maintainer@linuxtv.org>,
       "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch, -git] drivers/media build fix for modular builds
References: <20080507134907.4417708b.sfr@canb.auug.org.au>	<48230C7B.90007@mandriva.org>	<200805082016.57622.gene.heskett@gmail.com> <20080508.171828.205600975.davem@davemloft.net>
In-Reply-To: <20080508.171828.205600975.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller skrev:
> From: Gene Heskett <gene.heskett@gmail.com>
> Date: Thu, 08 May 2008 20:16:57 -0400
> 
>> On Thursday 08 May 2008, Thomas Backlund wrote:
>>> Stephen Rothwell skrev:
>>>> Index: linux/drivers/media/Makefile
>>>> ===================================================================
>>>> --- linux.orig/drivers/media/Makefile
>>>> +++ linux/drivers/media/Makefile
>>>> @@ -2,6 +2,8 @@
>>>>  # Makefile for the kernel multimedia device drivers.
>>>>  #
>>>>
>>>> +obj-y := common/
>>>> +
>>>>  obj-$(CONFIG_VIDEO_MEDIA) += common/
>>>>
>>>>  # Since hybrid devices are here, should be compiled if DVB and/or V4L
>>> How about fixing this one already ?
>>>
>> Yes please, its biting me too.
> 
> Linus merged a version of a fix for this from Ingo earlier today.
> .
> 

OK, big thanks ;-)

--
Thomas


