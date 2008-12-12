Return-Path: <linux-kernel-owner+w=401wt.eu-S1754114AbYLLLNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbYLLLNu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 06:13:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755122AbYLLLNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 06:13:40 -0500
Received: from blaine.gmane.org ([80.91.229.8]:55165 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065AbYLLLNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 06:13:39 -0500
Message-ID: <49424419.1090103@redhat.com>
Date: Fri, 12 Dec 2008 11:59:37 +0100
From: Zdenek Kabelac <zkabelac@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: "Alexander E. Patrakov" 
	<public-patrakov-Re5JQEeQqe8AvxtiuMwx3w@hugh.gmane.org>
CC: reinette chatre 
	<public-reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@hugh.gmane.org>,
       "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" 
	<public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>,
       "linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" 
	<public-linux-wireless-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>
Subject: Re: iwlagn interrupt problem
References: <c072ca310812100638k6c15473brb89632a9c175a028@mail.gmail.com>	 <c072ca310812100710o58c38a27rba16ad2318a1cb95@mail.gmail.com>	 <1228929548.18730.21.camel@rc-desk> <c072ca310812110548s64612ac7icd6e9187aa4af75a@mail.gmail.com>
In-Reply-To: <c072ca310812110548s64612ac7icd6e9187aa4af75a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TMDA-Confirmed: Fri, 12 Dec 2008 12:13:09 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




Alexander E. Patrakov napsal(a):
> 2008/12/10 reinette chatre <reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>:
>> The messages you refer to are printed because a user space app
>> (wpa_supplicant or network manager) brings the wireless interface down
>> and up. Interrupts are disabled when interface is brought down and
>> reenabled when interface is brought up.
> 
> OK.
> 
>> The unresponsiveness is due to a bug that was fixed recently. The
>> patches have been merged into wireless-testing repo and will be included
>> in 2.6.29. If you want to try
>> the individual patches, please try:
>> http://marc.info/?l=linux-wireless&m=122824886623698&w=2
>> http://marc.info/?l=linux-wireless&m=122849275528102&w=2
> 
> These individual patches don't apply to 2.6.27.6, so I installed
> today's compat-wireless-2.6, and it seems to work. Thanks!
> 
> OTOH, are these patches a material for backporting into -stable?
> 

Hi

I assume that this backtrace I've got with 2.6.28-rc7 is the same issue ?
(If I get it right - this issue will not be fixed in 2.6.28 and is delay for 
2.6.29 ?))

usb 3-2: reset full speed USB device using uhci_hcd and address 9
Restarting tasks ... done.
e1000e 0000:00:19.0: irq 377 for MSI/MSI-X
e1000e 0000:00:19.0: irq 377 for MSI/MSI-X
ADDRCONF(NETDEV_UP): eth0: link is not ready
iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwl3945 0000:03:00.0: irq 376 for MSI/MSI-X
ADDRCONF(NETDEV_UP): wlan0: link is not ready
wlan0: direct probe to AP 00:11:d8:da:65:40 try 1
wlan0: direct probe to AP 00:11:d8:da:65:40 try 1
wlan0 direct probe responded
wlan0: authenticate with AP 00:11:d8:da:65:40
wlan0: authenticated
wlan0: associate with AP 00:11:d8:da:65:40
wlan0: RX AssocResp from 00:11:d8:da:65:40 (capab=0x401 status=0 aid=8)
wlan0: associated
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
wlan0: disassociating by local choice (reason=3)
wlan0: no IPv6 routers present
wlan0: direct probe to AP 00:11:d8:da:65:40 try 1
wlan0: direct probe to AP 00:11:d8:da:65:40 try 1
wlan0 direct probe responded
wlan0: authenticate with AP 00:11:d8:da:65:40
wlan0: authenticated
wlan0: associate with AP 00:11:d8:da:65:40
wlan0: RX ReassocResp from 00:11:d8:da:65:40 (capab=0x401 status=0 aid=8)
wlan0: associated
wlan0: No ProbeResp from current AP 00:11:d8:da:65:40 - assume out of range
iwl3945: Error sending REPLY_SCAN_CMD: time out after 500ms.
iwl3945: Error sending REPLY_RXON_ASSOC: time out after 500ms.
iwl3945: Error setting RXON_ASSOC configuration (-110).
iwl3945: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
iwl3945: Error sending REPLY_RXON_ASSOC: time out after 500ms.
iwl3945: Error setting RXON_ASSOC configuration (-110).
iwl3945: Error sending REPLY_RXON_ASSOC: time out after 500ms.
iwl3945: Error setting RXON_ASSOC configuration (-110).
iwl3945: Error sending REPLY_QOS_PARAM: time out after 500ms.
iwl3945: Error sending REPLY_QOS_PARAM: time out after 500ms.
iwl3945: Error sending REPLY_QOS_PARAM: time out after 500ms.
iwl3945: Error sending REPLY_QOS_PARAM: time out after 500ms.
iwl3945: Error sending REPLY_RXON: time out after 500ms.
iwl3945: Error setting new configuration (-110).
wlan0: direct probe to AP 00:11:d8:da:65:40 try 1
iwl3945: Error sending REPLY_RXON: time out after 500ms.
iwl3945: Error setting new configuration (-110).
iwl3945: Error sending REPLY_RXON: time out after 500ms.
iwl3945: Error setting new configuration (-110).
wlan0: direct probe to AP 00:11:d8:da:65:40 try 1
wlan0: direct probe to AP 00:11:d8:da:65:40 try 2
wlan0: direct probe to AP 00:11:d8:da:65:40 try 3
wlan0: direct probe to AP 00:11:d8:da:65:40 timed out
iwl3945: Error sending REPLY_RXON: time out after 500ms.
iwl3945: Error setting new configuration (-110).
iwl3945: Error sending REPLY_RXON: time out after 500ms.
iwl3945: Error setting new configuration (-110).
iwl3945: Error sending REPLY_RXON: time out after 500ms.
iwl3945: Error setting new configuration (-110).
iwl3945: Error sending REPLY_RXON: time out after 500ms.
iwl3945: Error setting new configuration (-110).
wlan0: direct probe to AP 00:11:d8:da:65:40 try 1
wlan0: direct probe to AP 00:11:d8:da:65:40 try 2
wlan0: direct probe to AP 00:11:d8:da:65:40 try 3
wlan0: direct probe to AP 00:11:d8:da:65:40 timed out
iwl3945: Error sending REPLY_SCAN_CMD: time out after 500ms.
iwl3945: Error sending REPLY_RXON: time out after 500ms.
iwl3945: Error setting new configuration (-110).
iwl3945: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
iwl3945: Error sending REPLY_SCAN_CMD: time out after 500ms.
iwl3945: Error sending REPLY_RXON: time out after 500ms.
iwl3945: Error setting new configuration (-110).
iwl3945: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
iwl3945: Error sending REPLY_SCAN_CMD: time out after 500ms.
iwl3945: Error sending REPLY_RXON: time out after 500ms.
iwl3945: Error setting new configuration (-110).
iwl3945: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
iwl3945: Error sending REPLY_SCAN_CMD: time out after 500ms.
iwl3945: Error sending REPLY_RXON: time out after 500ms.
iwl3945: Error setting new configuration (-110).
iwl3945: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
iwl3945: Error sending REPLY_RXON: time out after 500ms.
iwl3945: Error setting new configuration (-110).
iwl3945: Error sending REPLY_RXON: time out after 500ms.
iwl3945: Error setting new configuration (-110).
iwl3945: No space for Tx
iwl3945: Error sending REPLY_RXON: iwl3945_enqueue_hcmd failed: -28
iwl3945: Error setting new configuration (-28).
iwl3945: No space for Tx
iwl3945: Error sending REPLY_RXON: iwl3945_enqueue_hcmd failed: -28
iwl3945: Error setting new configuration (-28).
wlan0: direct probe to AP 00:11:d8:da:65:40 try 1
wlan0: direct probe to AP 00:11:d8:da:65:40 try 2
wlan0: direct probe to AP 00:11:d8:da:65:40 try 3
wlan0: direct probe to AP 00:11:d8:da:65:40 timed out
iwl3945: No space for Tx
iwl3945: Error sending REPLY_SCAN_CMD: iwl3945_enqueue_hcmd failed: -28
iwl3945: No space for Tx
iwl3945: Error sending REPLY_RXON: iwl3945_enqueue_hcmd failed: -28
iwl3945: Error setting new configuration (-28).
iwl3945: No space for Tx
iwl3945: Error sending REPLY_TX_PWR_TABLE_CMD: iwl3945_enqueue_hcmd failed: -28
iwl3945: No space for Tx
iwl3945: Error sending REPLY_SCAN_CMD: iwl3945_enqueue_hcmd failed: -28
iwl3945: No space for Tx
iwl3945: Error sending REPLY_RXON: iwl3945_enqueue_hcmd failed: -28
iwl3945: Error setting new configuration (-28).
iwl3945: No space for Tx
iwl3945: Error sending REPLY_TX_PWR_TABLE_CMD: iwl3945_enqueue_hcmd failed: -28
iwl3945: No space for Tx
iwl3945: Error sending REPLY_SCAN_CMD: iwl3945_enqueue_hcmd failed: -28
iwl3945: No space for Tx
iwl3945: Error sending REPLY_RXON: iwl3945_enqueue_hcmd failed: -28
iwl3945: Error setting new configuration (-28).
iwl3945: No space for Tx
iwl3945: Error sending REPLY_TX_PWR_TABLE_CMD: iwl3945_enqueue_hcmd failed: -28
iwl3945: No space for Tx
iwl3945: Error sending REPLY_SCAN_CMD: iwl3945_enqueue_hcmd failed: -28
iwl3945: No space for Tx
iwl3945: Error sending REPLY_RXON: iwl3945_enqueue_hcmd failed: -28
iwl3945: Error setting new configuration (-28).
iwl3945: No space for Tx
iwl3945: Error sending REPLY_TX_PWR_TABLE_CMD: iwl3945_enqueue_hcmd failed: -28
iwl3945: No space for Tx
iwl3945: Error sending REPLY_SCAN_CMD: iwl3945_enqueue_hcmd failed: -28
iwl3945: No space for Tx
iwl3945: Error sending REPLY_RXON: iwl3945_enqueue_hcmd failed: -28
iwl3945: Error setting new configuration (-28).
iwl3945: No space for Tx
iwl3945: Error sending REPLY_TX_PWR_TABLE_CMD: iwl3945_enqueue_hcmd failed: -28
iwl3945: No space for Tx
iwl3945: Error sending REPLY_RXON: iwl3945_enqueue_hcmd failed: -28
iwl3945: Error setting new configuration (-28).
iwl3945: No space for Tx
iwl3945: Error sending REPLY_RXON: iwl3945_enqueue_hcmd failed: -28
iwl3945: Error setting new configuration (-28).
iwl3945: No space for Tx
iwl3945: Error sending REPLY_RXON: iwl3945_enqueue_hcmd failed: -28
iwl3945: Error setting new configuration (-28).
iwl3945: No space for Tx
iwl3945: Error sending REPLY_RXON: iwl3945_enqueue_hcmd failed: -28
iwl3945: Error setting new configuration (-28).
wlan0: direct probe to AP 00:11:d8:da:65:40 try 1
wlan0: direct probe to AP 00:11:d8:da:65:40 try 2
wlan0: direct probe to AP 00:11:d8:da:65:40 try 3
wlan0: direct probe to AP 00:11:d8:da:65:40 timed out
iwl3945: No space for Tx
iwl3945: Error sending REPLY_SCAN_CMD: iwl3945_enqueue_hcmd failed: -28
iwl3945: No space for Tx
iwl3945: Error sending REPLY_RXON: iwl3945_enqueue_hcmd failed: -28
iwl3945: Error setting new configuration (-28).
iwl3945: No space for Tx
iwl3945: Error sending REPLY_TX_PWR_TABLE_CMD: iwl3945_enqueue_hcmd failed: -28
iwl3945: No space for Tx
iwl3945: Error sending REPLY_SCAN_CMD: iwl3945_enqueue_hcmd failed: -28
iwl3945: No space for Tx
iwl3945: Error sending REPLY_RXON: iwl3945_enqueue_hcmd failed: -28
iwl3945: Error setting new configuration (-28).
iwl3945: No space for Tx
iwl3945: Error sending REPLY_TX_PWR_TABLE_CMD: iwl3945_enqueue_hcmd failed: -28
iwl3945: No space for Tx
iwl3945: Error sending REPLY_SCAN_CMD: iwl3945_enqueue_hcmd failed: -28
iwl3945: No space for Tx
iwl3945: Error sending REPLY_RXON: iwl3945_enqueue_hcmd failed: -28
iwl3945: Error setting new configuration (-28).
iwl3945: No space for Tx
iwl3945: Error sending REPLY_TX_PWR_TABLE_CMD: iwl3945_enqueue_hcmd failed: -28
iwl3945: No space for Tx
iwl3945: Error sending REPLY_SCAN_CMD: iwl3945_enqueue_hcmd failed: -28
iwl3945: No space for Tx
iwl3945: Error sending REPLY_RXON: iwl3945_enqueue_hcmd failed: -28
iwl3945: Error setting new configuration (-28).
iwl3945: No space for Tx
iwl3945: Error sending REPLY_TX_PWR_TABLE_CMD: iwl3945_enqueue_hcmd failed: -28


Zdenek


