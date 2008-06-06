Return-Path: <linux-kernel-owner+w=401wt.eu-S1755874AbYFFMd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbYFFMd1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 08:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbYFFMdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 08:33:16 -0400
Received: from mbox1.netikka.net ([213.250.81.202]:36801 "EHLO
	mbox1.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbYFFMdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 08:33:15 -0400
Message-ID: <48492E85.6010307@mandriva.org>
Date: Fri, 06 Jun 2008 15:33:09 +0300
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080504)
MIME-Version: 1.0
To: Tomas Winkler <tomasw@gmail.com>
CC: Ian Schram <ischram@telenet.be>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwl4965 oops in 2.6.26-rc5 x86_64
References: <4848289D.1080205@mandriva.org>	 <1ba2fa240806051103q652accf5t1bd1d94630ebea5b@mail.gmail.com>	 <48482BC3.4070402@mandriva.org> <4848482C.2080208@mandriva.org>	 <48485F12.2050908@mandriva.org> <48488878.5040708@telenet.be> <1ba2fa240806060432t73ecb318x89e877241aa6ef55@mail.gmail.com> <48492734.9080901@mandriva.org>
In-Reply-To: <48492734.9080901@mandriva.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Backlund skrev:
> Tomas Winkler skrev:
>> On Fri, Jun 6, 2008 at 3:44 AM, Ian Schram <ischram@telenet.be> wrote:
>>> Isn't this the Oops Joonwoo Park wanted to patch with
>>>
>>> "[PATCH] iwlwifi: fix oops on wep key insertion" 27/5/2008
>>>
>>> invalid length of webkey that would/should be handled in mac80211?
>>>
>>> ian
>>
>> Yes, it looks like.
> 
> Ummm, what has a wep key to do with me trying to access a WPA2-Personal 
> encrypted net ?
> 
>> Thomas can you send out your wpa_supplicant config fiele
>>
> 
> I could, but since I would have to remove any sensitive info such as the 
> psk key, would it be of any use ?

Anyway, here configs are:

wpa_supplicant.conf
(I stripped all the comments from the file)
--- cut ---
ctrl_interface=/var/run/wpa_supplicant

eapol_version=1

ap_scan=1

fast_reauth=1

blob-base64-exampleblob={
SGVsbG8gV29ybGQhCg==
}

network={
     psk="*************************"
     scan_ssid=1
     ssid="dlink"
}
--- cut ---

ifcfg-wlan0
--- cut ---
DEVICE=wlan0
BOOTPROTO=dhcp
ONBOOT=yes
METRIC=35
MII_NOT_SUPPORTED=no
USERCTL=no
RESOLV_MODS=no
WIRELESS_MODE=Managed
WIRELESS_ESSID=dlink
WIRELESS_ENC_KEY='s:*************************'
WIRELESS_WPA_DRIVER=wext
IPV6INIT=no
IPV6TO4INIT=no
DHCP_CLIENT=dhclient
NEEDHOSTNAME=no
PEERDNS=yes
PEERYP=yes
PEERNTPD=no
--- cut ---

> 
>> I will provide a patch that disable hw encryption on long wep keys. It
>> get lost in my todo list.
>> Tomas
>>
> 

-- 
Thomas


