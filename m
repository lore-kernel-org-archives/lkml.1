Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456AbXEZX3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbXEZX3R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 19:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751107AbXEZX3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 19:29:09 -0400
Received: from terminus.zytor.com ([192.83.249.54]:40576 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbXEZX3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 19:29:08 -0400
Message-ID: <4658C2C1.7060607@zytor.com>
Date: Sat, 26 May 2007 16:29:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MIPS: Transform old-style macros to newer "__noreturn"
 standard.
References: <Pine.LNX.4.64.0705251418050.13623@localhost.localdomain> <46572DAF.1000108@zytor.com> <Pine.LNX.4.64.0705251458440.13906@localhost.localdomain> <46573B23.1090700@zytor.com> <Pine.LNX.4.64.0705260924370.19438@localhost.localdomain> <4658781D.5070108@zytor.com>
In-Reply-To: <4658781D.5070108@zytor.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Robert P. J. Day wrote:
>> It does not make sense for a noreturn function to have a return type
>> other than void.
>> ^^^^^ ^^^^ ^^^^
>> ===============================================================
>>
>>   so I'm just going to stick with the pattern that's been used so far.
>> i realize it offends your sense of syntactic sensibility, but it's
>> just not worth treating that one attribute so differently from the
>> rest of them.
>>
> 
> Why are you so hung up over the fact that the *implementation* of this
> is an attribute?  You're totally confusing interface and implementation.
> 

Perhaps I should clarify this:

The whole reason to abstract this as a macro *at all* is to take it away
from the specific implementation in gcc.  Thus, implementing an inferior
interface just because gcc happens to do it that way is actively
counterproductive.

	-hpa
