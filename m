Return-Path: <linux-kernel-owner+w=401wt.eu-S932812AbXCUQN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812AbXCUQN2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 12:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932753AbXCUQN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 12:13:26 -0400
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:48541 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932817AbXCUQNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 12:13:12 -0400
Message-ID: <46015990.0@lwfinger.net>
Date: Wed, 21 Mar 2007 11:13:04 -0500
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Zan Lynx <zlynx@acm.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, bluez-devel@lists.sourceforge.net,
       reiserfs-dev@namesys.com
Subject: Re: 2.6.21-rc4-mm1
References: <20070319205623.299d0378.akpm@linux-foundation.org>	<1174433034.62033.16.camel@localhost> <20070320223643.d8cbc3f6.akpm@linux-foundation.org>
In-Reply-To: <20070320223643.d8cbc3f6.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 20 Mar 2007 17:23:54 -0600 Zan Lynx <zlynx@acm.org> wrote:
> 
>> On Mon, 2007-03-19 at 20:56 -0800, Andrew Morton wrote:
>>> Temporarily at
>>>
>>>   http://userweb.kernel.org/~akpm/2.6.21-rc4-mm1/
>>>
>>> Will appear later at
>>>
>>>   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc4/2.6.21-rc4-mm1/
>> First impressions:
>> Several of the same bugs as rc3-mm*:
>>       * Freezes immediately if I touch the wlan0 device after loading
>>         the new Broadcom wireless driver.

--snip--

>> 02:02.0 Network controller: Broadcom Corporation BCM4303 802.11b Wireless LAN Controller (rev 02)

I'm a little confused. The bcm43xx-mac80211 driver does not handle 802.11b devices, and the
bcm43xx-softmac driver should not freeze. Which one was configured here?

Larry
