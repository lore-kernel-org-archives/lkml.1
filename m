Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbZLWXXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbZLWXXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 18:23:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755835AbZLWXXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 18:23:45 -0500
Received: from smtp13.ono.com ([62.42.230.16]:47309 "EHLO resmaa13.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755762AbZLWXXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 18:23:45 -0500
Date: Thu, 24 Dec 2009 00:23:42 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Problems with ath5k and WPA2 keys
Message-ID: <20091224002342.59a9a021@werewolf.home>
X-Mailer: Claws Mail 3.7.3cvs45 (GTK+ 2.19.2; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all...

With last 2.6.32.2 kernel, I can't connect to my home WiFi router.
I use WPA2+PSK mode.

I have discovered it's related to key length:

one:~# iwconfig wlan0 key s:password
Error for wireless request "Set Encode" (8B2A) :
    SET failed on device wlan0 ; Invalid argument.
one:~# iwconfig wlan0 key s:passwor
Error for wireless request "Set Encode" (8B2A) :
    SET failed on device wlan0 ; Invalid argument.
one:~# iwconfig wlan0 key s:passwo
Error for wireless request "Set Encode" (8B2A) :
    SET failed on device wlan0 ; Invalid argument.
one:~# iwconfig wlan0 key s:passw

(this last works...)

So network scripts can not set my key...

I don't know if this is a problem in iwconfig or in the driver...

Any idea ? Any way to debug this ?

pd: hardware is Acer Aspire One 150:

03:00.0 Ethernet controller: Atheros Communications Inc. AR5001 Wireless Network Adapter (rev 01)
    Subsystem: Foxconn International, Inc. Device e008
    Flags: bus master, fast devsel, latency 0, IRQ 18
    Memory at 35200000 (64-bit, non-prefetchable) [size=64K]
    Capabilities: [40] Power Management version 2
    Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit-
    Capabilities: [60] Express Legacy Endpoint, MSI 00
    Capabilities: [90] MSI-X: Enable- Count=1 Masked-
    Capabilities: [100] Advanced Error Reporting
    Capabilities: [140] Virtual Channel <?>
    Kernel driver in use: ath5k
    Kernel modules: ath5k

TIA

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2010.0 (Cooker) for x86_64
Linux 2.6.29.3-desktop-1mnb (gcc 4.3.2 (GCC) #1 Wed May
