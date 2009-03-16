Return-Path: <linux-kernel-owner+w=401wt.eu-S1757511AbZCPQbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbZCPQbu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 12:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752361AbZCPQbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 12:31:40 -0400
Received: from mail-bw0-f175.google.com ([209.85.218.175]:54813 "EHLO
	mail-bw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbZCPQbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 12:31:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=TNv97w9VcbVG+DWSdeqgn+SsGa2C2UE6YTFcZoP/JCUIhk/4mpSY/y3xXzPkxgRVYA
         13ETLVohA86/yDakXApNBO8+zAsQx0jrW5xK2+m0CQnGdInPdr76Z3mvIXGpDjgV4LMP
         gCl4RSPXgFlSKpP7Bzw6vLxpeTT60YG/ngmYA=
Message-ID: <49BE7EE6.3070107@gmail.com>
Date: Mon, 16 Mar 2009 17:31:34 +0100
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
References: <49BCDCAA.8040309@gmail.com>	 <d3f22a0903152046m891dc0aq6ca01eed32a9eb32@mail.gmail.com> <1237174943.4193.37.camel@minggr.sh.intel.com>
In-Reply-To: <1237174943.4193.37.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.3.2009 04:42, Lin Ming wrote:
>> sometimes, when booting up/resuming from disk, I get an oops[1].
>>
>> obj_desc->common_field.access_bit_width is zero, but even after the
>> loop. Division before the loop is apparently OK.
>
> Would please try below debug patch to see which region filed is
> accessed?

Yes, except the fact, we wouldn't see anything :) -- I'll add inside the 
if a return statement or something to disallow the oops to flood screen.

Also, it doesn't happen regularly. Mostly several first tries after cold 
start. I hope this is a regression and not a HW problem, but it emerged 
after switching to 2.6.29-*, I will keep you informed.

Thanks.
