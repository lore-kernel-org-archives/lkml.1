Return-Path: <linux-kernel-owner+w=401wt.eu-S932139AbZABTge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139AbZABTge (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 14:36:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbZABTgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 14:36:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60758 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbZABTgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 14:36:24 -0500
Message-ID: <495E6C96.3040102@kernel.org>
Date: Fri, 02 Jan 2009 11:35:50 -0800
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, ath9k-devel@venema.h4ckr.net,
       linux-wireless@vger.kernel.org
Subject: Re: tip - Solution of ath9k: turn off temporarily (66b5c4a2c638b5a69d3e41abe4a2bae55035a92e)
References: <3f9a31f40901020936l4bed87e2jb64678572d2ad45b@mail.gmail.com>	 <20090102180730.GA10072@elte.hu> <3f9a31f40901021040l2afb5e19sc37e61d3f9728531@mail.gmail.com>
In-Reply-To: <3f9a31f40901021040l2afb5e19sc37e61d3f9728531@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
>>
>> diff --git a/drivers/net/wireless/ath9k/Kconfig b/drivers/net/wireless/ath9k/Kconfig
>> index c43bd32..b849a45 100644
>> --- a/drivers/net/wireless/ath9k/Kconfig
>> +++ b/drivers/net/wireless/ath9k/Kconfig
>> @@ -1,6 +1,8 @@
>>  config ATH9K
>>        tristate "Atheros 802.11n wireless cards support"
>>        depends on PCI && MAC80211 && WLAN_80211
>> +       # build failures
>> +       depends on 0
>>        select MAC80211_LEDS
>>        select LEDS_CLASS
>>        select NEW_LEDS
>>
> 

I thought the proper way to do this was "depends on BROKEN"...

	-hpa

