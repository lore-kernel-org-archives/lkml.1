Return-Path: <linux-kernel-owner+w=401wt.eu-S1760918AbYETHGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760918AbYETHGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 03:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755853AbYETHGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 03:06:43 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:23275
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737AbYETHGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 03:06:42 -0400
Message-ID: <48327880.70104@qumranet.com>
Date: Tue, 20 May 2008 10:06:40 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make LIST_POISON less deadly
References: <1211125094-32167-1-git-send-email-avi@qumranet.com> <20080519130151.GE13546@elte.hu> <4831845F.6030904@qumranet.com> <20080519190438.GB24599@uranus.ravnborg.org>
In-Reply-To: <20080519190438.GB24599@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
>> Any idea how to override a value in Kconfig?  We can do it for bool 
>> values but not strings.
>>
>> e.g.
>>
>> lib/Kconfig:
>>  config ILLEGAL_POINTER_VALUE
>>      hex
>>      default 0
>>
>> arch/x86/Kconfig:
>>  config X86
>>    select ILLEGAL_POINTER_VALUE=0x80000000000000000000000000 if X86_64
>>
>> ?
>>
>> I could do it with a boolean signifying existence and a hex for the 
>> value, but I'd rather not.
>>     
>
> Sorry - no help here. I have not tried to work that much with int in
> Kconfig.
>
>   

I found some workaround (define the variable only on archs that want it, 
use #ifdef to check).

> That said I really think stuff like this belongs in a header file.
> I do not agree to hide this as part of the configuration.
>   

While I agree with you, I defer to Ingo on this.

-- 
error compiling committee.c: too many arguments to function

