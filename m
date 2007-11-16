Return-Path: <linux-kernel-owner+w=401wt.eu-S1759045AbXKPKiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759045AbXKPKiD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 05:38:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331AbXKPKhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 05:37:52 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:48774 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbXKPKhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 05:37:51 -0500
Message-ID: <473D6CAC.9010404@in.ibm.com>
Date: Fri, 16 Nov 2007 15:40:52 +0530
From: "B. N. Poornima" <poornima@in.ibm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Nathan Lynch <ntl@pobox.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Martin J. Bligh" <mbligh@mbligh.org>, roland@topspin.com
Subject: Re: [PATCH] prom_find_machine_type typo breaks pSeries lpar boot
References: <374360000.1117810369@[10.10.2.4]> <52is0vwd49.fsf@topspin.com> <20050603182725.GB11355@otto> <52vf4vuum5.fsf@topspin.com> <20050603192525.GC11355@otto> <1117839500.31082.188.camel@gaston> <473AE9BE.8070001@in.ibm.com> <20071114193733.GK26313@localdomain>
In-Reply-To: <20071114193733.GK26313@localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nathan Lynch wrote:
> Hi-
>
> B. N. Poornima wrote:
>   
>>> On Fri, 2005-06-03 at 14:25 -0500, Nathan Lynch wrote:
>>>  
>>>       
>>>> Typo in prom_find_machine_type from Ben's recent patch "ppc64: Fix
>>>> result code handling in prom_init" prevents pSeries LPAR systems from
>>>> booting.
>>>>
>>>>         
>> Hello,
>> Same typo has creped in again from 2.6.17 kernel onwards and causing 
>> open firmware exception in pSeries systems.
>>     
>
> Looking at the current code, I don't see how this analysis could be
> correct.
>   
   You are right. Sorry for the confusion. I had overlooked the changes 
in the code (prom_init.c) Will check if
   the problem still persists on the latest version. Thanks!
>   
>> The patch that is provided solves the problem.
>>     
>
> Which patch?  Did you forget to include it?
>
> It would be best if you sent your problem report and any patches to
> linuxppc-dev@ozlabs.org.  linuxppc64-dev is dead.
>
> Thanks.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>   

