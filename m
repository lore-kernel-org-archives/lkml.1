Return-Path: <linux-kernel-owner+w=401wt.eu-S1758263AbXELSHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263AbXELSHz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 14:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758041AbXELSHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 14:07:35 -0400
Received: from terminus.zytor.com ([192.83.249.54]:48016 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757902AbXELSHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 14:07:34 -0400
Message-ID: <46460223.5090909@zytor.com>
Date: Sat, 12 May 2007 11:06:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Satyam Sharma <satyam.sharma@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Johannes Stezenbach <js@linuxtv.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Heikki Orsila <shdl@zakalwe.fi>,
       jimmy bahuleyan <knight.camelot@gmail.com>
Subject: Re: [PATCH] "volatile considered harmful", take 3
References: <12700.1178905000@lwn.net>	 <a781481a0705112021u7b6d32fcxb6318d7e2443c970@mail.gmail.com>	 <464551D5.2050709@zytor.com>	 <a781481a0705112315u5843abaar292859428ec60603@mail.gmail.com>	 <46455CD9.7010205@zytor.com> <a781481a0705120002xb604e7al629ceb1c27109451@mail.gmail.com> <4645691C.5090408@zytor.com> <4645725F.3060809@s5r6.in-berlin.de>
In-Reply-To: <4645725F.3060809@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> H. Peter Anvin wrote:
> [slightly off topic: GCCisms in Linux kernel]
>> It contains *many* constructs that are not defined in, for
>> example, C99, and it would in fact be impossible to write the Linux
>> kernel using only C99-compliant constructs.
> 
> True.  On the other hand, it is possible to keep large parts of the
> kernel independent of compiler implementation details.  And it is not
> only possible but also beneficial, e.g. because the compiler's
> implementation changes over time.

It is, but this is not likely to be one of those things.

Either way, I fully agree with the following (from Jeff):

> jimmy bahuleyan wrote:
>> i believe, the doc here is pretty unambiguous regarding the fact that
>> volatile should be avoided. And as Stefan pointed out, anyone who feels
>> the need to use, must surely _know_ what he is doing & hence is in a
>> position t make that decision
> 
> Honestly, the above quoted paragraph states the situation better than any long, complicated document.

	-hpa
