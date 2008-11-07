Return-Path: <linux-kernel-owner+w=401wt.eu-S1753210AbYKGO5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbYKGO5R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 09:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750962AbYKGO5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 09:57:07 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:9196 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbYKGO5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 09:57:05 -0500
Message-ID: <49145738.2030108@mimas.ru>
Date: Fri, 07 Nov 2008 18:56:56 +0400
From: Constantin Baranov <const@mimas.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.17) Gecko/20080930 SeaMonkey/1.1.12
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2.6.28-rc3] led: ALIX.2 LEDs driver
References: <491097D7.4030800@mimas.ru> <20081107135250.GA1437@ucw.cz>
In-Reply-To: <20081107135250.GA1437@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Tue 2008-11-04 22:43:35, Constantin Baranov wrote:
>> Driver for PC Engines ALIX.2 and ALIX.3 LEDs.
>>
>> Signed-off-by: Constantin Baranov <const@mimas.ru>
>> ---
>> Changes from previous version:
>>  - rename from LEDS_ALIX to LEDS_ALIX2, because driver may not work
>>    with possible future ALIX boards
>>  - scan BIOS area (000f0000:000fffff) to ensure that current system
>>    is ALIX.2/3
>>  - add module parameter 'force' to allow registering LEDs without
>>    BIOS test (e.g. if stock BIOS was upgraded)
> 
> What kind of ninja mutant system is that? Can't you identify it using
> DMI or something?
> 

This is minimalistic single board system.
It doesn't contain any specific PCI devices.
Linux says "DMI not present or invalid."

I has no ideas how to identify ALIX, except
the Richard's idea of scanning BIOS.
