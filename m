Return-Path: <linux-kernel-owner+w=401wt.eu-S1753390AbXEYRJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbXEYRJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 13:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763086AbXEYRJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 13:09:11 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:5636 "EHLO
	outbound3-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762926AbXEYRJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 13:09:09 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.66.75;Service: EHS
Message-ID: <4657182E.4060404@am.sony.com>
Date: Fri, 25 May 2007 10:09:02 -0700
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linuxppc-dev@ozlabs.org, Geert.Uytterhoeven@sonycom.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 4/7] ps3: Storage Driver Probing
References: <20070525083607.784351000@sonycom.com>	<20070525083632.474400000@sonycom.com> <200705251818.03964.arnd@arndb.de>
In-Reply-To: <200705251818.03964.arnd@arndb.de>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 May 2007 17:09:03.0723 (UTC) FILETIME=[654C73B0:01C79EEF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Arnd Bergmann wrote:
>> +	switch (dev_type) {
>> +	case PS3_DEV_TYPE_STOR_DISK:
>> +		match_id = PS3_MATCH_ID_STOR_DISK;
>> +		break;
>> +
>> +	case PS3_DEV_TYPE_STOR_ROM:
>> +		match_id = PS3_MATCH_ID_STOR_ROM;
>> +		break;
>> +
>> +	case PS3_DEV_TYPE_STOR_FLASH:
>> +		match_id = PS3_MATCH_ID_STOR_FLASH;
>> +		break;
>> +
>> +	default:
>> +		return 0;
>> +	}
> 
> Why do you have separate constants for PS3_DEV_TYPE_* and
> PS3_MATCH_ID_*? If you don't do any conversion, this driver
> will immediately work for additional types as well, if more
> get added later.

I noticed we have some redundancy in the constants and such
now that we have unified the device support.  I planned to go
through and try to clean up what I can.

-Geoff




