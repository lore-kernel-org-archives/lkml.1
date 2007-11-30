Return-Path: <linux-kernel-owner+w=401wt.eu-S935514AbXK3RYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935514AbXK3RYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 12:24:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762955AbXK3RX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 12:23:56 -0500
Received: from smtp151.sat.emailsrvr.com ([66.216.121.151]:39805 "EHLO
	smtp151.sat.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762936AbXK3RXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 12:23:55 -0500
Message-ID: <4750471F.5050007@keyspan.com>
Date: Fri, 30 Nov 2007 09:23:43 -0800
From: Lucy McCoy <lucy@keyspan.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: bbpetkov@yahoo.de
CC: Andrew Morton <akpm@linux-foundation.org>, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] keyspan: init termios properly
References: <46954.192.168.1.71.1195161016.webmail@192.168.1.71> <20071118131130.GA3991@gollum.tnic> <20071126141852.a609cdb6.akpm@linux-foundation.org> <20071130054500.GB17350@gollum.tnic>
In-Reply-To: <20071130054500.GB17350@gollum.tnic>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I've been too busy to get to this but i'd rather not use the code 
fragment i sent Boris to try.  It would be better to go ahead with the 
tty setup if the pointer is not NULL, otherwise use the defaults and not 
reference the NULL pointer. I'll see if I can get to this today.

Lucy


Borislav Petkov wrote:
> On Mon, Nov 26, 2007 at 02:18:52PM -0800, Andrew Morton wrote:
>   
>> On Sun, 18 Nov 2007 14:11:30 +0100
>> Borislav Petkov <bbpetkov@yahoo.de> wrote:
>>
>>     
>>> On Thu, Nov 15, 2007 at 01:10:16PM -0800, Lucy McCoy wrote:
>>>       
>
> ...
>
>   
>>> yes, after testing this i can confirm that this one fixes the NULL ptr
>>> problem here so you might want to submit a proper patch to Greg.
>>>       
>> I'll merge revert-keyspan-init-termios-properly.patch soon, but afaik we
>> are still awaiting the real fix for this problem?
>>     
>
> Hi Andrew,
> sorry for the late reply - i was away from the country and couldn't read mail.
> Yes, we are still awaiting the real fix afaik but the code fragment above
> removes the NULL ptr deref so we should at least merge that. Will prepare a
> patch for this later today...
>
>   
