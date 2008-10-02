Return-Path: <linux-kernel-owner+w=401wt.eu-S1755281AbYJBWDD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbYJBWDD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 18:03:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbYJBWCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 18:02:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:18480 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754381AbYJBWCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 18:02:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,353,1220252400"; 
   d="scan'208";a="622773443"
Message-ID: <48E5450C.60701@intel.com>
Date: Thu, 02 Oct 2008 15:02:52 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080626)
MIME-Version: 1.0
To: Niel Lambrechts <niel.lambrechts@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: FYI: e1000e: corruption, Lenovo/IBM are replacing my MB.
References: <biyi4-2jF-23@gated-at.bofh.it> <48E5418D.3000307@devnull.org>
In-Reply-To: <48E5418D.3000307@devnull.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 02 Oct 2008 22:02:52.0811 (UTC) FILETIME=[9DF1CDB0:01C924DA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Niel Lambrechts wrote:
> On 10/02/2008 05:30 PM, Lee.Mathers@tcafs.org wrote:
>> Fyi,  lenovo/ibm(Canada) are replacing the Motherboard on my T61 (6465-9TU)
>> Intel®82566DC Gigabit Network Card. MAC ADDRR now read's FF:FF:FF:FF:FF:FF:FF:FF
>>
>> (wink) I did not advise them that it may have been caused by a hiccup/glitch in the Linux Kernel and/or the e1000e driver for said system.
> 
> I have not followed all of this too closely, and installed
> linux-2.6.27-rc7-33 (OpenSUSE's KOTD) kernel in an attempt to get its
> wireless card going. When I booted I briefly saw a NVRAM warning and my
> laptop ended hanging on Firewall Initialization, without ever getting to
> a login prompt.
> 
> I immediately remembered this bug, but strangely seem not to be
> affected, since I could still use the card to connect to the internet
> after rebooting in 2.6.26.
> 
> My laptop's a Lenovo W500 with a fairly similar card:
> 
> # lspci|grep -i ethernet
> 00:19.0 Ethernet controller: Intel Corporation 82567LM Gigabit Network
> Connection (rev 03)
> 
> My EEP shows
> 
> Offset          Values
> ------          ------
> 0x0000          00 1c 25 95 93 ec 00 08 ff ff 83 10 ff ff ff ff
> 0x0010          08 10 ff ff c3 10 ee 20 aa 17 f5 10 86 80 00 00
> 0x0020          01 0d 00 00 00 00 05 86 20 30 00 0a 00 00 8b 8d
> 0x0030          02 06 40 2b 43 00 00 00 f5 10 ad ba f5 10 bf 10
> 0x0040          ad ba cb 10 ad ba ad ba 00 00 00 00 00 00 00 00
> 0x0050          00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 0x0060          00 01 00 40 18 13 07 40 ff ff ff ff ff ff ff ff
> 0x0070          ff ff ff ff ff ff ff ff ff ff ff ff ff ff 33 cb
> 0x0080          20 60 1f 00 02 00 13 00 00 80 1d 00 ff 00 16 00
> 0x0090          dd cc 18 00 11 20 17 00 dd dd 18 00 12 20 17 00
> 0x00a0          00 80 1d 00 00 00 1f 00 ff ff ff ff ff ff ff ff
> ... all ff ...
> 0x0ff0          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> 
> I hope it is still okay/valid!!?

your mac address certainly still looks ok, and from quickly browsing this eeprom
content certainly looks valid. (most eeproms indeed END in all 0xff bytes).

does the e1000e driver still load? do you get 'bad eeprom checksum' errors on boot?

please post a full dmesg...

Auke

