Return-Path: <linux-kernel-owner+w=401wt.eu-S1754476AbYKHPWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbYKHPWT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 10:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbYKHPWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 10:22:07 -0500
Received: from www17.your-server.de ([213.133.104.17]:57118 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbYKHPWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 10:22:06 -0500
Subject: 2.6.28-rc3 (x86_64) on current Fedora 9 (i386)
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 08 Nov 2008 16:22:08 +0100
Message-Id: <1226157728.6060.7.camel@dhcppc0>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Cross compiled with gcc-4.2.4.

nm-applet seems to constantly fail to connect my wlan:

[  415.702723] rndis_wlan 1-6.3:1.0: rndis media connect
[  415.731909] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  415.732700] wpa_supplicant[3416]: segfault at fff40000 ip 000000004f612fd6 sp 00000000fff3c108 error 4 in libc-2.8.so[4f59c000+163000]
[  415.749491] rndis_wlan 1-6.3:1.0: rndis media disconnect
[  426.664267] wlan0: no IPv6 routers present
[  431.701722] rndis_wlan 1-6.3:1.0: rndis media connect
[  431.726008] wpa_supplicant[4055]: segfault at ffcc9000 ip 000000004f612fd6 sp 00000000ffcc6698 error 4 in libc-2.8.so[4f59c000+163000]
[  431.740094] rndis_wlan 1-6.3:1.0: rndis media disconnect
[  437.705723] rndis_wlan 1-6.3:1.0: rndis media connect
[  437.735135] wpa_supplicant[4160]: segfault at ffd88000 ip 000000004f612fd6 sp 00000000ffd83b98 error 4 in libc-2.8.so[4f59c000+163000]
[  437.754987] rndis_wlan 1-6.3:1.0: rndis media disconnect
[  443.705723] rndis_wlan 1-6.3:1.0: rndis media connect
[  443.735113] wpa_supplicant[4167]: segfault at fffa7000 ip 000000004f612fd6 sp 00000000fffa4978 error 4 in libc-2.8.so[4f59c000+163000]
[  443.751981] rndis_wlan 1-6.3:1.0: rndis media disconnect
[  459.705722] rndis_wlan 1-6.3:1.0: rndis media connect
[  459.736240] wpa_supplicant[4173]: segfault at ffe7d000 ip 000000004f612fd6 sp 00000000ffe7a048 error 4 in libc-2.8.so[4f59c000+163000]
[  459.750979] rndis_wlan 1-6.3:1.0: rndis media disconnect

The same kernel not cross compiled (with the supplied Fedora gcc) works correctly with the nm-applet...

Kernel or user land bug?

Also I get this strange error messages:
[   23.767645] ioctl32(rhgb:2177): Unknown cmd fd(13) cmd(0000530b){t:'S';sz:0} arg(4eed91aa) on /dev/pts/0
[   23.767652] ioctl32(rhgb:2177): Unknown cmd fd(13) cmd(0000530b){t:'S';sz:0} arg(4eed91af) on /dev/pts/0
[   23.767657] ioctl32(rhgb:2177): Unknown cmd fd(13) cmd(0000530b){t:'S';sz:0} arg(4eed91b6) on /dev/pts/0

[   46.273767] ioctl32(hald-probe-stor:2750): Unknown cmd fd(4) cmd(00005320){t:'S';sz:0} arg(00000004) on /dev/sr0

[  525.336420] ioctl32(gnome-terminal:4419): Unknown cmd fd(20) cmd(0000530b){t:'S';sz:0} arg(4eed91aa) on /dev/pts/1
[  525.336427] ioctl32(gnome-terminal:4419): Unknown cmd fd(20) cmd(0000530b){t:'S';sz:0} arg(4eed91af) on /dev/pts/1
[  525.336432] ioctl32(gnome-terminal:4419): Unknown cmd fd(20) cmd(0000530b){t:'S';sz:0} arg(4eed91b6) on /dev/pts/1

Should I care about these messages?

greets
thomas


