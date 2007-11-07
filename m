Return-Path: <linux-kernel-owner+w=401wt.eu-S1758053AbXKGJSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbXKGJSL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 04:18:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756120AbXKGJRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 04:17:54 -0500
Received: from sa14.bezeqint.net ([192.115.104.29]:46365 "EHLO
	sa14.bezeqint.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758071AbXKGJRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 04:17:50 -0500
Message-ID: <47318298.2030903@panasas.com>
Date: Wed, 07 Nov 2007 11:17:12 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add the macro to test if "exactly_one_bit_set" to log2.h.
References: <Pine.LNX.4.64.0711061135310.23545@localhost.localdomain> <4730AE66.6030501@panasas.com> <Pine.LNX.4.64.0711061352520.29701@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0711061352520.29701@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06 2007 at 20:53 +0200, "Robert P. J. Day" <rpjday@crashcourse.ca> wrote:
> On Tue, 6 Nov 2007, Boaz Harrosh wrote:
> 
>> On Tue, Nov 06 2007 at 18:38 +0200, "Robert P. J. Day" <rpjday@crashcourse.ca> wrote:
>>> While this macro is defined in terms of "is_power_of_2" and is
>>> therefore functionally equivalent, the visual semantics are sometimes
>>> more appropriate for what is actually being tested.
>>>
>>> Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
>>>
>>> ---
>>>
>>> diff --git a/include/linux/log2.h b/include/linux/log2.h
>>> index c8cf5e8..d0d324e 100644
>>> --- a/include/linux/log2.h
>>> +++ b/include/linux/log2.h
>>> @@ -55,6 +55,12 @@ bool is_power_of_2(unsigned long n)
>>>  }
>>>
>>>  /*
>>> + *  And for folks who want slightly different semantics ...
>>> + */
>>> +
>>> +#define exactly_one_bit_set is_power_of_2
>> at_most_one_bit_set No?
> 
> no, it really is *exactly* one bit set.  zero is not considered a
> power of two.
> 
> rday

Yes, Sorry for the noise it was late and I should have returned to
the kids instead of reading lkml.

Boaz
