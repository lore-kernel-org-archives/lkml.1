Return-Path: <linux-kernel-owner+w=401wt.eu-S1755371AbYKKBal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbYKKBal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 20:30:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754192AbYKKBaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 20:30:00 -0500
Received: from mail.tpi.com ([198.107.51.143]:4313 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107AbYKKB36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 20:29:58 -0500
Message-ID: <4918E004.8000205@canonical.com>
Date: Mon, 10 Nov 2008 18:29:40 -0700
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: tcanonical@tpi.com, bryan.stillwell@hp.com, Mike.Miller@hp.com,
       iss_storagedev@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cciss: firmware version is invalid
References: <20081106201204.9C2AEF8A65@sepang.rtg.net>	<1226005890.13433.390.camel@aki.stillwell>	<49144CB8.8070604@tpi.com> <20081110165558.428566ab.akpm@linux-foundation.org>
In-Reply-To: <20081110165558.428566ab.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 07 Nov 2008 07:12:08 -0700
> Tim Gardner <tcanonical@tpi.com> wrote:
> 
>> Stillwell, Bryan wrote:
>>> Tim,
>>>
>>> Thanks for getting this merged, but I believe this patch is preferred
>>> over the original one I attached:
>>>
>>> http://userweb.kernel.org/~akpm/mmotm/broken-out/cciss-fix-regression-firmware-not-displayed-in-procfs-again-and-again.patch
>>>
>>> The reason for this according to Mike Miller is: "The first fix could be
>>> called anytime something changed on the controller such as number of
>>> logical volumes, etc.  This patch will get called only once for each
>>> controller."
>>>
>>> Thanks,
>>> Bryan
>> applied
>>
> 
> I'm all confused here.
> 
> cciss-fix-regression-firmware-not-displayed-in-procfs-again-and-again.patch
> is now in mainline.  Are you saying that "cciss: Firmware Version is
> invalid" is preferred?  That "cciss: Firmware Version is invalid"
> should still be applied?
> 
> If so, "cciss: Firmware Version is invalid" will need a better title
> and changelog, please.  The one you have there is pretty skimpy. 
> reading between the lines, I'm guessing that the driver emits "Firmware
> Version is invalid" messages and that this patch somehow fixes that?
> 

Andrew,

The patch in Linus' repo looks correct, so please drop this one. At the
time I sent the original patch I didn't realize there was another
version already staged for Linus.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
