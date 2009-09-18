Return-Path: <linux-kernel-owner+w=401wt.eu-S1758074AbZIRUTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074AbZIRUTk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 16:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757539AbZIRUTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 16:19:38 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:40234 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757485AbZIRUTh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 16:19:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BaBSL6enjFfngwbCOVyt/vXQJiy0u/XtYh0Lvn3NB6cnW9RrjUxUUCfV2/CGV6nTu4
         5CIpbTb5BBeefKoEljgDo0jiQ/LiMP9vhI5Np/Vkz50TF0IysLK6R5eDx/TEMKeWUzVU
         GoGH7sS7Fg8lA4lQcAk//59Oowqd1QKCZ4Vao=
MIME-Version: 1.0
In-Reply-To: <1253299494.26521.664.camel@rc-desk>
References: <8db1092f0909160236i5d2b1f31k3ec289fbd9ac0bfa@mail.gmail.com>
	 <1253122055.26521.431.camel@rc-desk>
	 <8db1092f0909161036t5bae781eqa6f0a0df308ec4cd@mail.gmail.com>
	 <1253124149.26521.438.camel@rc-desk>
	 <8db1092f0909161259i5e007282i42f426bc2d0fc0c4@mail.gmail.com>
	 <1253139186.26521.449.camel@rc-desk>
	 <8db1092f0909162332r4ffeef09jdb87f7fc69ff8e9e@mail.gmail.com>
	 <1253299494.26521.664.camel@rc-desk>
Date: Fri, 18 Sep 2009 22:19:39 +0200
Message-ID: <8db1092f0909181319h3dfec7cya391df705b7723b2@mail.gmail.com>
Subject: Re: [Ilw] Re: WARNING: at net/mac80211/scan.c:267 
	ieee80211_scan_completed+0x299/0x2b0 [mac80211]()
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "ilw@linux.intel.com" <ilw@linux.intel.com>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/18 reinette chatre <reinette.chatre@intel.com>:
> Hi Maciej,
>
> On Wed, 2009-09-16 at 23:32 -0700, Maciej Rutecki wrote:
>
>> [  249.340094] wlan0: direct probe to AP 00:1b:11:f6:0f:28 (try 1)
>> [  249.345339] wlan0 direct probe responded
>> [  249.345347] wlan0: authenticate with AP 00:1b:11:f6:0f:28 (try 1)
>> [  249.347122] wlan0: authenticated
>> [  249.347152] wlan0: associate with AP 00:1b:11:f6:0f:28 (try 1)
>> [  249.349703] wlan0: RX AssocResp from 00:1b:11:f6:0f:28 (capab=0x431
>> status=0 aid=1)
>> [  249.349711] wlan0: associated
>> [  253.411858] wlan0: deauthenticated from 00:1b:11:f6:0f:28 (Reason:
>> 6)
>
> This still appears to be the main issue here, that AP deauthenticates.
> Could you run wpa_supplicant with debugging (-dddt) ? When you have
> these logs, could you please open a bug report at
> http://bugzilla.intellinuxwireless.org/ to enable us to track it?

Sure, bug report:
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2089

Debug information also available:
http://unixy.pl/maciek/download/kernel/2.6.31-git4/wpa_debug.txt

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
