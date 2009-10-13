Return-Path: <linux-kernel-owner+w=401wt.eu-S1759981AbZJMOYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759981AbZJMOYv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 10:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759902AbZJMOYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 10:24:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36877 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759945AbZJMOYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 10:24:50 -0400
Message-ID: <4AD48D8B.10609@suse.com>
Date: Tue, 13 Oct 2009 10:24:11 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-1.1 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jonathan Cameron <Jonathan.Cameron@gmail.com>
Cc: Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: Complete sched.h removal from interrupt.h
References: <4AD39B4A.6030305@suse.com> <4AD45F94.8060806@gmail.com>
In-Reply-To: <4AD45F94.8060806@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2009 07:08 AM, Jonathan Cameron wrote:
> Hi Jeff,
>>  drivers/staging/iio/industrialio-core.c    |    2 ++
>>   
> ...
>> --- a/drivers/staging/iio/industrialio-core.c
>> +++ b/drivers/staging/iio/industrialio-core.c
>> @@ -19,6 +19,8 @@
>>  #include <linux/interrupt.h>
>>  #include <linux/poll.h>
>>  #include <linux/cdev.h>
>> +#include <linux/sched.h>
>> +#include <linux/wait.h>
>>  #include "iio.h"
>>  #include "trigger_consumer.h"
>>   
> Greg has already picked up a patch for this one, but might make more
> sense to drop
> that and merge all these fixes as one.  Original patch only added
> sched.h though.
> Is wait.h due to a similar issue that is going to bite in the future?
> (could chase this
> down but as you added it seemed easier to ask!)

Nope, I think iio was probably the first driver I saw this build failure
in and observed that it was in the wait queue code. It's not necessary,
though it doesn't cost anything either since wait.h is already included
somewhere.

-Jeff

-- 
Jeff Mahoney
SUSE Labs
