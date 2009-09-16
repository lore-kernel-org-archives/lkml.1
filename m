Return-Path: <linux-kernel-owner+w=401wt.eu-S1759170AbZIPRhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759170AbZIPRhD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 13:37:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbZIPRg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 13:36:57 -0400
Received: from mail-ew0-f227.google.com ([209.85.219.227]:63495 "EHLO
	mail-ew0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022AbZIPRg4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 13:36:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DhBGFmxz4fCJk1ch/QzUlws3NPVuw/Cj4EpLrNVoVvQ5QZmzVEtTkPNiQh/oqxkDjw
         4gQ0CTo9wUSvvwkJkuKx/lsFriGI8AKfKRUC/TaAK0HPZjeySWkPYSdw5eSE20dNegxg
         hlGYrZm9klzkLxSr+PfByh30RGdsFQEXqliqY=
MIME-Version: 1.0
In-Reply-To: <1253122055.26521.431.camel@rc-desk>
References: <8db1092f0909160236i5d2b1f31k3ec289fbd9ac0bfa@mail.gmail.com>
	 <1253122055.26521.431.camel@rc-desk>
Date: Wed, 16 Sep 2009 19:36:57 +0200
Message-ID: <8db1092f0909161036t5bae781eqa6f0a0df308ec4cd@mail.gmail.com>
Subject: Re: WARNING: at net/mac80211/scan.c:267 ieee80211_scan_completed+0x299/0x2b0 
	[mac80211]()
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       "ilw@linux.intel.com" <ilw@linux.intel.com>,
       "Zhu, Yi" <yi.zhu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/16 reinette chatre <reinette.chatre@intel.com>:
>
> The important information is not what you posted here, but still in the
> dmesg file you provided. In that log we see the following right before
> the warnings:
>
> [  163.126590] wlan0: direct probe to AP 00:1b:11:f6:0f:28 (try 1)
> [  163.130027] wlan0 direct probe responded
> [  163.130032] wlan0: authenticate with AP 00:1b:11:f6:0f:28 (try 1)
> [  163.131924] wlan0: authenticated
> [  163.131952] wlan0: associate with AP 00:1b:11:f6:0f:28 (try 1)
> [  163.134325] wlan0: RX ReassocResp from 00:1b:11:f6:0f:28 (capab=0x431 status=0 aid=1)
> [  163.134331] wlan0: associated
> [  163.155938] wlan0: deauthenticating by local choice (reason=3)
>
> It shows that association was successful, but something in userspace requested a disconnect.

Hmm. Yes, connect takes more time than in 2.6.31.
>
>>
>> [  163.208063] ------------[ cut here ]------------
>> [  163.208114] WARNING: at net/mac80211/scan.c:267
>> ieee80211_scan_completed+0x299/0x2b0 [mac80211]()
>
> I cannot get an exact line match based on the kernel information you
> provided. I assume it is the first warning in
> ieee80211_scan_completed(). This is not serious as it indicates that
> mac80211 received a "scan completed" indication when it was not
> scanning.
>
>
>> [  163.232845] ------------[ cut here ]------------
>> [  163.232908] WARNING: at net/wireless/core.c:613
>> wdev_cleanup_work+0xbb/0xe0 [cfg80211]()
>
> This warning has just been reported in linux-wireless also. Perhaps you
> can follow its discussion there. See
> http://thread.gmane.org/gmane.linux.kernel.wireless.general/39607

Thanks for information


-- 
Maciej Rutecki
http://www.maciek.unixy.pl
