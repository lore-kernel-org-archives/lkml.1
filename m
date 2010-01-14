Return-Path: <linux-kernel-owner+w=401wt.eu-S1757461Ab0ANS6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461Ab0ANS6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 13:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757445Ab0ANS6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 13:58:17 -0500
Received: from mail.windriver.com ([147.11.1.11]:60457 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756951Ab0ANS6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 13:58:16 -0500
Message-ID: <4B4F691F.3030500@windriver.com>
Date: Thu, 14 Jan 2010 12:57:35 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, linux-arm-kernel@lists.infradead.org
Subject: Re: Re: [PATCH 20/40] arm,kgdb: Add hook to catch an oops with debugger
References: <1263481176-1897-1-git-send-email-jason.wessel@windriver.com><1263481176-1897-21-git-send-email-jason.wessel@windriver.com> <20100114174821.GB21385@n2100.arm.linux.org.uk>
In-Reply-To: <20100114174821.GB21385@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jan 2010 18:57:38.0110 (UTC) FILETIME=[70CDC5E0:01CA954B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux wrote:
> On Thu, Jan 14, 2010 at 08:59:16AM -0600, Jason Wessel wrote:
>   
>> Add in a low level hook to catch calls to die() in the debugger.
>>
>> After the debugger is done, the standard system rules will be in play
>> for the original exception.
>>
>> The kdb debugger wants a chance to catch these sorts of exceptions for
>> analysis.
>>     
>
> NAK.  I have a similar patch which implements the hook properly - but
> with one caveat.  It needs a review to ensure that its safe to return
> from die().  Until that's established, this patch can not be merged.
>   

I dropped the patch which you NAK'ed from the series.

As for your included patch, I will try it out  against the various
regression tests I have, which exercise the oops and exception paths.

> Please also ensure that the linux-arm-kernel list is copied with ARM
> patches.
>
>   

Check.


Thanks,
Jason.
