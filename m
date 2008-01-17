Return-Path: <linux-kernel-owner+w=401wt.eu-S1755585AbYAQJyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbYAQJyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 04:54:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751588AbYAQJx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 04:53:58 -0500
Received: from slowhand.arndnet.de ([88.198.19.76]:58599 "EHLO mail.unitix.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751132AbYAQJx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 04:53:57 -0500
Message-ID: <478F25D6.3060503@i4.informatik.rwth-aachen.de>
Date: Thu, 17 Jan 2008 10:54:30 +0100
From: Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andres Salomon <dilinger@queued.net>
CC: linux-kernel@vger.kernel.org, Jordan Crouse <jordan.crouse@amd.com>
Subject: Re: 2.6.24-rc8 hangs at mfgpt-timer
References: <478E4267.7020509@i4.informatik.rwth-aachen.de> <20080116161912.7b449466@ephemeral> <20080116165606.3ebc06a4@ephemeral>
In-Reply-To: <20080116165606.3ebc06a4@ephemeral>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andres Salomon schrieb:
> On Wed, 16 Jan 2008 16:19:12 -0500
> Andres Salomon <dilinger@queued.net> wrote:
> 
>> On Wed, 16 Jan 2008 18:44:07 +0100
>> Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de> wrote:
>>
>>> Hi,
>>>
>>> I'm trying to boot 2.6.24-rc8 on a GEODE LX board (ALIX.3),
>>> and it hangs during boot:
>>>
>>> [   12.689971] NET: Registered protocol family 16
>>> [   12.703329] geode-mfgpt:  Registered timer 0
>>> [   12.716149] mfgpt-timer:  registering the MFGT timer as a clock event...
>>>
>>
>> What BIOS are you using?  It's possible that our detection code is
>> failing to detect in-use timers.

I'm using v0.99 (latest available).
Also note when I do enable the mysterios "MFGPT workaround" option in
the bios the machine hangs directly after:
[   36.780990] NET: Registered protocol family 16

> 
> 
> Also, could you provide a log with the following (untested) patch?  I'm
> curious how many MFGPTs we're actually detecting as being available, and
> the existing code is backwards.

The relevant part would be:
[   23.092507] NET: Registered protocol family 16
[   23.105875] geode-mfgpt:  8 MFGPT timers available
[   23.120247] geode-mfgpt:  Registered timer 0
[   23.133076] mfgpt-timer:  registering the MFGT timer as a clock event.

Best regards,
Arnd Hannemann

