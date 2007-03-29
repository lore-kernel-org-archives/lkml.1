Return-Path: <linux-kernel-owner+w=401wt.eu-S1753745AbXC2OlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbXC2OlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 10:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753750AbXC2OlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 10:41:21 -0400
Received: from mail.tmr.com ([64.65.253.246]:52416 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753745AbXC2OlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 10:41:21 -0400
Message-ID: <460BCF8E.7030705@tmr.com>
Date: Thu, 29 Mar 2007 10:39:10 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: eranian@hpl.hp.com
CC: Folkert van Heusden <folkert@vanheusden.com>,
       Vignesh Babu BM <vignesh.babu@wipro.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, ak@suse.de,
       Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: kmalloc() with size zero
References: <20070323001824.GA26540@frankl.hpl.hp.com> <Pine.LNX.4.61.0703230237390.9555@yvahk01.tjqt.qr> <1174624770.10742.2.camel@wriver-t81fb058.linuxcoe> <20070325163013.GW741@vanheusden.com> <20070326080908.GF9144@frankl.hpl.hp.com>
In-Reply-To: <20070326080908.GF9144@frankl.hpl.hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane Eranian wrote:
> Hi,
> 
> On Sun, Mar 25, 2007 at 06:30:34PM +0200, Folkert van Heusden wrote:
>>>> I'd say "feature", glibc's malloc also returns an address on
>>>> malloc(0).
>>>>
>>> This is implementation defined-the standard allows for return of either
>>> null or an address.
>> Entirely for entertainment: AIX (5.3) returns NULL, IRIX returns a valid
>> address.
>>
> That's interesting, so many different behaviors! Personally, I still prefer
> when malloc(0) returns zero because it makes it easier to catch errors.
> 
Exactly, the address returned is not really useful, the improved error 
checking is useful.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
