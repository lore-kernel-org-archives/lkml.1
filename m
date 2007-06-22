Return-Path: <linux-kernel-owner+w=401wt.eu-S1750936AbXFVNT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750936AbXFVNT5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 09:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510AbXFVNTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 09:19:50 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:51824 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbXFVNTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 09:19:49 -0400
Message-ID: <467BCB99.8030003@gmail.com>
Date: Fri, 22 Jun 2007 15:16:09 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Bart Trojanowski <bart@jukie.net>, linux-kernel@vger.kernel.org
Subject: Re: how to tell linux (on x86) to ignore 1M or memory
References: <20070419141804.GO32620@jukie.net> <46290DED.80500@gmail.com> <467B29DA.9040309@zytor.com>
In-Reply-To: <467B29DA.9040309@zytor.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2007 03:46 AM, H. Peter Anvin wrote:

> Rene Herman wrote:
>> On 04/19/2007 04:18 PM, Bart Trojanowski wrote:
>>
>>> I need to preserve some state from the bios before entering protected
>>> mode.  For now I want to copy it into some ram accessible by
>>> real-mode, say the last megabyte visible in real-mode.
>>>
>>> What's the easiest way to have linux ignore the megabyte starting at 15M?
>> Note that real-mode can only access the first megabyte (*) and not the
>> first 16. 16MB is the 16-bit protected mode (286) limit.
>>
> 
> No, 16-bit protected mode (on 386+) is not limited to 16 MB.

That all depends on one's definition of 16-bit protected mode. The "(286)" 
after mine meant I was talking about the definition in which descriptors 
have a 24-bit base (and 16-bit limit) field -- ie, real 286 and arguably, 
"real 16-bit protected mode".

Yes, I guess another valid definition is "code with a 16-bit address and 
operand size default" on a 386+ and sure, that's just flipping a bit away.
In the context of Linux I agree it's also a sensible definition, so, well, 
whatever. The point was that real mode could only access the first 1M, not 
the first 16... :-)

Rene.

