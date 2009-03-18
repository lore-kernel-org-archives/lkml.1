Return-Path: <linux-kernel-owner+w=401wt.eu-S1754328AbZCRIJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbZCRIJP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 04:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750835AbZCRII6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 04:08:58 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:57730 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbZCRII4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 04:08:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=fo5j8f5vGBSTAbr/QA07dUj9IF2x24G35uGtvZD7pdnyxURJqBXOQIiFYb1S2L39hI
         BElaePrW67uoCi5EHlS/Pq34fDs9zRuHt0jL9ihodQCseWcMRhRZFtu2iowddDJIASvq
         JFhDUDqCLETLgwGrvsjBUTbDaMO4LFVCY5pgo=
Message-ID: <49C0AC13.7040107@gmail.com>
Date: Wed, 18 Mar 2009 09:08:51 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-3.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Lin Ming <ming.m.lin@intel.com>
CC: robert.moore@intel.com, lenb@kernel.org, linux-acpi@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       torvalds@linux-foundation.org
Subject: Re: 2.6.29 acpi regression: acpi_ex_extract_from_field -- div by
 zero
References: <49BCDCAA.8040309@gmail.com>	 <d3f22a0903152046m891dc0aq6ca01eed32a9eb32@mail.gmail.com> <1237174943.4193.37.camel@minggr.sh.intel.com> <49BE7EE6.3070107@gmail.com>
In-Reply-To: <49BE7EE6.3070107@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.3.2009 17:31, Jiri Slaby wrote:
> On 16.3.2009 04:42, Lin Ming wrote:
>>> sometimes, when booting up/resuming from disk, I get an oops[1].
>>>
>>> obj_desc->common_field.access_bit_width is zero, but even after the
>>> loop. Division before the loop is apparently OK.
>>
>> Would please try below debug patch to see which region filed is
>> accessed?
>
> Yes, except the fact, we wouldn't see anything :) -- I'll add inside the
> if a return statement or something to disallow the oops to flood screen.
>
> Also, it doesn't happen regularly. Mostly several first tries after cold
> start. I hope this is a regression and not a HW problem, but it emerged
> after switching to 2.6.29-*, I will keep you informed.

Hmm, I didn't see it with rc8 and this patch applied so far (no 'ACPI 
Debug' in dmesg). Also I don't see anything changed within drivers/acpi/ 
et al. between rc7 and rc8. Maybe the timing changed somewhere else... 
I'm confused, but keep trying.
