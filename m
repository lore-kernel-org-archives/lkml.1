Return-Path: <linux-kernel-owner+w=401wt.eu-S1753129AbYJVQsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbYJVQsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 12:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbYJVQru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 12:47:50 -0400
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:46283 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751226AbYJVQrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 12:47:49 -0400
Message-ID: <48FF5933.3080501@lwfinger.net>
Date: Wed, 22 Oct 2008 09:47:47 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>
CC: Jouni Malinen <jouni.malinen@atheros.com>,
       wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       John Linville <linville@tuxdriver.com>
Subject: Re: Regression in 2.6.27-git from commit 43ac2ca3840f64
References: <48FDFCCA.8040604@lwfinger.net> <20081022072840.GD16005@jm.kir.nu>
In-Reply-To: <20081022072840.GD16005@jm.kir.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jouni Malinen wrote:
> On Tue, Oct 21, 2008 at 09:01:14AM -0700, Larry Finger wrote:
> 
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
> 
> ...
> 
>> This problem was bisected to commit 43ac2ca3840f64f699a239535c590fa7ebaaac27,
>> entitled "mac80211: Handle scan result IEs in one block". The same bug is
>> present in the wireless-testing tree.
> 
> Problem? Bug? This is by design. What does not work for you?

When a utility starts spitting messages that it doesn't understand what the
kernel is providing _AND_ the commit message does not mention that this will
happen, can someone be blamed for thinking it is a bug?

Clearly this is not a regression. Are there plans to update the wireless utilities?

Larry
