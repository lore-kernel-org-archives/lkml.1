Return-Path: <linux-kernel-owner+w=401wt.eu-S1752579AbYG1Nxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbYG1Nxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 09:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbYG1Nxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 09:53:43 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:20123 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbYG1Nxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 09:53:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=P2PrK/dC6dwnrtwPm81TQMcjHYLCw4QKiXsIlmxByPrBqW6aomqEAsg4vJClXZgGxH
         aRJbYOAu/3Dha5I+HL/A6D6J7eDMF4ZVl0Ps64mPP/iPfa2KiPlwiuoN9mhc0tRsUHEV
         tZCCd+t75JEguvH8kmssqEhUcMsfd7mPU3P4Q=
Message-ID: <dd18b0c30807280653q6c11cd6aia20946f6fd9acf0c@mail.gmail.com>
Date: Mon, 28 Jul 2008 06:53:41 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: NETDEV WATCHDOG: wifi0: transmit timed out
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080728061226.26ffae06@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30807280010h34002232wb53b7a154d9853fc@mail.gmail.com>
	 <20080728061226.26ffae06@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 6:12 AM, Arjan van de Ven <arjan@infradead.org> wrote:
> On Mon, 28 Jul 2008 00:10:46 -0700
> "Justin Mattock" <justinmattock@gmail.com> wrote:
>
>> I should'nt be posting this, due to
>> having  tainted modules(madwifi), but
>
> and fglrx
>
>> I figured I might as well:(below)
>>
>> [ 5000.986044] NETDEV WATCHDOG: wifi0: transmit timed out
>
> and what's more... it's the the wifi that's b0rked.
>
> sounds like you want to switch to ath5k or ath9k.
>
>
> --
> If you want to reach me at my work email, use arjan@linux.intel.com
> For development, discussion and tips for power savings,
> visit http://www.lesswatts.org
>

If there's support for the 5418 card that the macbook pro has.
interesting when lspci I'm not seeing the card number(below is lspci)
As for the fglrx "f*&k it" too much of a pain.:


00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS/940GML and
945GT Express Memory Controller Hub (rev 03)
00:01.0 PCI bridge: Intel Corporation Mobile 945GM/PM/GMS/940GML and
945GT Express PCI Express Root Port (rev 03)
00:07.0 Performance counters: Intel Corporation Unknown device 27a3 (rev 03)
00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High
Definition Audio Controller (rev 02)
00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 1 (rev 02)
00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 2 (rev 02)
00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 3 (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI #3 (rev 02)
00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI #4 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2
EHCI Controller (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface
Bridge (rev 02)
00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE
Controller (rev 02)
00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family)
Serial ATA Storage Controller IDE (rev 02)
00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 02)
01:00.0 VGA compatible controller: ATI Technologies Inc Unknown device 71c5
02:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8053
PCI-E Gigabit Ethernet Controller (rev 22)
03:00.0 Network controller: Atheros Communications, Inc. Unknown
device 0024 (rev 01)
0c:03.0 FireWire (IEEE 1394): Texas Instruments TSB82AA2 IEEE-1394b
Link Layer Controller (rev 01)

unkown device 0024!
I hope my wireless card isn't broken.
regards;
-- 
Justin P. Mattock
