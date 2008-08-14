Return-Path: <linux-kernel-owner+w=401wt.eu-S1755278AbYHNX5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbYHNX5H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 19:57:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbYHNX4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 19:56:53 -0400
Received: from smtp.ono.com ([62.42.230.12]:21968 "EHLO resmaa01.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751424AbYHNX4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 19:56:52 -0400
X-Greylist: delayed 315 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Aug 2008 19:56:51 EDT
Date: Fri, 15 Aug 2008 01:51:31 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: ath5k on the Acer Aspire One
Message-ID: <20080815015131.39bb20ef@werewolf.home>
X-Mailer: Claws Mail 3.5.0cvs31 (GTK+ 2.13.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi...

I have just got a One, and have installed a standard distro (not Linpus),
Mandriva in my case.

Everything works pretty nicely but WiFi. Hardware is:

03:00.0 Ethernet controller: Atheros Communications Inc. AR242x 802.11abg Wireless PCI Express Adapter (rev 01)

The driver used is ath5k. On load, it logs this:


Aug 15 01:13:57 one klogd: ath5k_pci 0000:03:00.0: registered as 'phy0'
Aug 15 01:13:57 one klogd: ath5k phy0: Support for RF2425 is under development.
Aug 15 01:13:57 one klogd: ath5k phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)

But when I try to connect, I see:

one:~# wpa_supplicant -i wlan0 -c /etc/wpa_supplicant.conf -D wext
ioctl[SIOCSIWAUTH]: Operation not supported
WEXT auth param 4 value 0x0 - CTRL-EVENT-SCAN-RESULTS
CTRL-EVENT-SCAN-RESULTS

wpa_supplicant.conf just has this:

network={
    ssid="werewolf"
#    scan_ssid=1
    proto=WPA2
    key_mgmt=WPA-PSK
    psk="xxxxxx"
}

And the interface does not see any network. My router is a WRT54GL running
Tomato 1.21, and the wireless scan feature of tomato does not show the
emitter in the laptop.

One detail, the wifi light in the lid is not lit, and if I push the wifi
button I get this message:

Aug 15 01:34:16 one klogd: atkbd.c: Unknown key pressed (translated set 2, code 0xd6 on isa0060/serio0).
Aug 15 01:34:16 one klogd: atkbd.c: Use 'setkeycodes e056 <keycode>' to make it known.
Aug 15 01:34:16 one klogd: atkbd.c: Unknown key released (translated set 2, code 0xd6 on isa0060/serio0).
Aug 15 01:34:16 one klogd: atkbd.c: Use 'setkeycodes e056 <keycode>' to make it known.

Well, I thought I needed 'acerhk', so loaded it:


Aug 15 01:34:32 one klogd: input: Acer hotkey driver as /class/input/input9
Aug 15 01:34:33 one klogd: acerhk: Could not find model string, will assume type 200 series
Aug 15 01:34:33 one klogd: Acer Travelmate hotkey driver v0.5.35

But get the same messages.

So perhaps the problem is just that wifi is disabled, and I cant enable it
because an driver understands the codes from the button in the case.

Any idea ?

BTW, can I force the interface on when loading ath5k ?

TIA

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.0 (Cooker) for i586
Linux 2.6.25-jam18 (gcc 4.3.1 20080626 (GCC) #1 SMP
