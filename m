Return-Path: <linux-kernel-owner+w=401wt.eu-S933385AbXBAGtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933385AbXBAGtz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 01:49:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161136AbXBAGtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 01:49:55 -0500
Received: from terminus.zytor.com ([192.83.249.54]:42777 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933385AbXBAGty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 01:49:54 -0500
Message-ID: <45C18D87.6000905@zytor.com>
Date: Wed, 31 Jan 2007 22:49:43 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Sebastian Kemper <sebastian_ml@gmx.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-rc7 mtrr handling
References: <200701312046.02196.sebastian_ml@gmx.net> <45C18506.5090001@zytor.com> <200702010738.39497.sebastian_ml@gmx.net>
In-Reply-To: <200702010738.39497.sebastian_ml@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian Kemper wrote:
> On Thursday 01 February 2007 07:13, you wrote:
>> Sebastian Kemper wrote:
>>> But now /proc/mtrr shows 256MB of video ram, same as lspci, whereas
>>> the real amount of video ram (as properly detected by X) is only
>>> 128MB.
>> The size of the aperture doesn't have to match the actual amount of
>> memory.  For many cards it doesn't.
>>
>> 	-hpa
> 
> Hello Peter,
> 
> sorry, I don't understand. Are you talking about the AGP Aperture size 
> that I can set in my BIOS or about the actual video ram on the graphics 
> card. Because that's the one that the mtrr sets to its double size.

Neither.  I'm talking about the window in the address space, as shown in 
/proc/pci.

	-hpa
