Return-Path: <linux-kernel-owner+w=401wt.eu-S1422723AbXCWIp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422723AbXCWIp5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 04:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422696AbXCWIp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 04:45:57 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3371 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422723AbXCWIp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 04:45:56 -0400
Message-ID: <460393A3.60502@shadowen.org>
Date: Fri, 23 Mar 2007 08:45:23 +0000
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Con Kolivas <kernel@kolivas.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steve Fox <drfickle@us.ibm.com>, "Martin J. Bligh" <mbligh@mbligh.org>
Subject: Re: 2.6.21-rc4-mm1
References: <20070319205623.299d0378.akpm@linux-foundation.org> <4602B7D3.4030108@shadowen.org> <4602C83B.20608@shadowen.org> <200703231718.20647.kernel@kolivas.org>
In-Reply-To: <200703231718.20647.kernel@kolivas.org>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:
> On Friday 23 March 2007 05:17, Andy Whitcroft wrote:
>> Ok, I have yet a third x86_64 machine is is blowing up with the latest
>> 2.6.21-rc4-mm1+hotfixes+rsdl-0.32 but working with
>> 2.6.21-rc4-mm1+hotfixes-RSDL.  I have results on various hotfix levels
>> so I have just fired off a set of tests across the affected machines on
>> that latest hotfix stack plus the RSDL backout and the results should be
>> in in the next hour or two.
>>
>> I think there is a strong correlation between RSDL and these hangs.  Any
>> suggestions as to the next step.
> 
> Found a nasty in requeue_task
> +	if (list_empty(old_array->queue + old_prio))
> +		__clear_bit(old_prio, p->array->prio_bitmap);
> 
> see anything wrong there? I do :P
> 
> I'll queue that up with the other changes pending and hopefully that will fix 
> your bug.

Tests queued with your rdsl-0.33 patch (I am assuming its in there).
Will let you know how it looks.

-apw

