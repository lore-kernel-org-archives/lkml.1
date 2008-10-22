Return-Path: <linux-kernel-owner+w=401wt.eu-S1753445AbYJVCeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbYJVCeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 22:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbYJVCel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 22:34:41 -0400
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:45456 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751014AbYJVCek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 22:34:40 -0400
Message-ID: <48FE913D.9060205@lwfinger.net>
Date: Tue, 21 Oct 2008 19:34:37 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Jouni Malinen <jouni.malinen@atheros.com>,
       wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       John Linville <linville@tuxdriver.com>
Subject: Re: Regression in 2.6.27-git from commit 43ac2ca3840f64
References: <48FDFCCA.8040604@lwfinger.net>	 (sfid-20081021_232731_453910_0675C4D6) <1224624636.28639.15.camel@johannes.berg>
In-Reply-To: <1224624636.28639.15.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Berg wrote:
> On Tue, 2008-10-21 at 09:01 -0700, Larry Finger wrote:
>> On my x86_64 system, the mainline 2.6.27-git kernel (v2.6.27-6030-g6da0b38)
>> shows the following anomaly with the 'iwlist scan' command:
>>
>>           Cell 03 - Address: 00:14:BF:85:49:FA
>>                     ESSID:"lwfdjf"
>>                     Mode:Master
>>                     Channel:1
>>                     Frequency:2.412 GHz (Channel 1)
>>                     Quality=66/100  Signal level:-62 dBm  Noise level=-68 dBm
>>                     Encryption key:on
>>                     IE: Unknown: 00066C7766646A66
>>                     IE: Unknown: 010882848B962430486C
>>                     IE: Unknown: 030101
>>                     IE: Unknown: 2A0104
>>                     IE: Unknown: 2F0104
>>                     IE: Unknown: 32040C121860
>>                     IE: Unknown: DD09001018020014000000
>>                     IE: WPA Version 1
>>                         Group Cipher : TKIP
>>                         Pairwise Ciphers (1) : TKIP
>>                         Authentication Suites (1) : PSK
>>                     Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 18 Mb/s
>>                               24 Mb/s; 36 Mb/s; 54 Mb/s; 6 Mb/s; 9 Mb/s
>>                               12 Mb/s; 48 Mb/s
>>                     Extra:tsf=0000014488aeb18b
>>                     Extra: Last beacon: 448ms ago
>>
>> This problem was bisected to commit 43ac2ca3840f64f699a239535c590fa7ebaaac27,
>> entitled "mac80211: Handle scan result IEs in one block". The same bug is
>> present in the wireless-testing tree.
> 
> I'm probably too tired, what exactly is the problem?

The unknown IE's don't show up before this commit.

Larry
