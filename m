Return-Path: <linux-kernel-owner+w=401wt.eu-S1757953AbYHGVfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953AbYHGVfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 17:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756213AbYHGVfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 17:35:16 -0400
Received: from mail.hauppauge.com ([167.206.143.4]:4360 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755881AbYHGVfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 17:35:14 -0400
Message-ID: <489B6A66.40605@linuxtv.org>
From: mkrufky@linuxtv.org
To: khali@linux-fr.org
Cc: sam@ravnborg.org, user.kernel@gmail.com, linux-kernel@vger.kernel.org,
       i2c@lm-sensors.org
Subject: Re: Problem with restricted I2C algorithms in kernel 2.6.26!
Date: Thu, 7 Aug 2008 17:34:30 -0400 
MIME-Version: 1.0
X-Mailer: Internet Mail Service (5.5.2657.72)
x-originalarrivaltime: 07 Aug 2008 21:32:37.0513 (UTC) FILETIME=[1CCF4F90:01C8F8D5]
user-agent: Thunderbird 2.0.0.16 (Windows/20080708)
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> Hi Michael,
>
> On Thu, 7 Aug 2008 15:03:36 -0400, Michael Krufky wrote:
>   
>> I agree with Trent and D.Kelly
>>
>> These options should be made available to the user -- We should go
>> with the patch that Jean posted, "Subject: i2c: Let users select
>> algorithm drivers manually again" -- this is a fair compromise for
>> both sides -- users that dont know should leave the automatic
>> selection enabled.  Users that know better can disable the automatic
>> selection and enable what they need.
>>
>> The statement, "just have the external driver merged into the kernel"
>> is not a solution.
>>     
>
> Why not, please? A vast majority of drivers work fine that way today. I
> am still waiting for someone to give me a good reason why some other
> drivers supposedly can't be merged upstream (something better than
> "believe me, it's impossible".)
>
>   

Nobody said that a driver "...can't be merged upstream" ...  but 
REQUIRING a driver to be merged upstream to allow development and / or 
testing is a problem, IMHO.

If you required that all of my development happens within a git 
development repository, preventing me from working against distro-kernel 
xyz, then I would simply spend more time on Windows driver development 
and my Linux contributions would cease.

External subsystem development repositories allow us to work against 
stable kernels at our own pace.  When driver X is ready to be merged, it 
gets merged.

With the model that you propose, "use linux-next for development" ... 
well then what about testing?  Who is going to test my driver if it 
requires a full kernel compile?

Khali, you know me, and you know that I am always in favor of merging 
drivers into the kernel.  The ability to choose a kernel's features is 
an option that should not be removed.

>> Removing the option to build those additional algos is a regression, IMHO
>>     
>
> Will be addressed soon, do not worry.
Regards,

Mike
