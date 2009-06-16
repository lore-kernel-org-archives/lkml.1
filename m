Return-Path: <linux-kernel-owner+w=401wt.eu-S1761025AbZFPRp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761025AbZFPRp3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 13:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759086AbZFPRpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 13:45:20 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:2018 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758387AbZFPRpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 13:45:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=EIGjQIgZpLlr4f2KIWKTegBpCYt7DocmZ5LT0VtayNg4T7KCfSYLrvGzJUwd6xC3dH
         BYYSgyEPLuoe9442LKXIX2IcW5cBxAAoCBJq4YT6FJM10OjyD3ZQTFEMCyQpxQux8njV
         Oa61UL7Htv4tOeSLz4ZaA6G71hFsFgaW9ZSUs=
Message-ID: <4A37DA2C.8020106@gmail.com>
Date: Tue, 16 Jun 2009 10:45:16 -0700
From: Richard Henderson <rth7680@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: ink@jurassic.park.msu.ru, lkml <linux-kernel@vger.kernel.org>,
       linux-alpha@vger.kernel.org
Subject: Re: [PATCH] Convert alpha to use arch_gettimeoffset()
References: <1244758210.7192.5.camel@localhost.localdomain>	 <4A31FDBE.3030506@gmail.com> <1244832112.7231.3.camel@localhost.localdomain>
In-Reply-To: <1244832112.7231.3.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz wrote:
> On Fri, 2009-06-12 at 00:03 -0700, Richard Henderson wrote:
>   
>> john stultz wrote:
>>     
>>> I suspect the alpha arch could even be further improved to provide and
>>> rpcc() based clocksource, but not having the hardware, I don't feel
>>> comfortable attempting the more complicated conversion (but I'd be glad
>>> to help if anyone else is interested).
>>>       
>> Unfortunately this isn't possible.  The rpcc value is only 32-bits wide,
>> and so rolls over in approx 3 to 4 seconds.  Thus all the contortions to
>> try and use the truncated value for sub 1 second adjustments.
>>     
>
> That's actually ok. The ACPI PM clocksource on x86 is only 24 bits wide
> and wraps every 5 seconds. The generic timekeeping code handles the
> wrapping and accumulation for you.
>   
Interesting.
> Might you create a patch that does this conversion and apply it on top
> of mine? 
Unfortunately I don't have working hardware anymore.  Perhaps Ivan will 
be able to help here.


r~
