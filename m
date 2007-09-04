Return-Path: <linux-kernel-owner+w=401wt.eu-S1755806AbXIDROb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806AbXIDROb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 13:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754779AbXIDROX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 13:14:23 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:52919 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbXIDROW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 13:14:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=DICWn2+IvNaaeVqhYq5uT6d/FcrOgs4yWvwpvzK3jp1b9rbvuaY7KItAMRoaYlLFjjkglWMQlHUWilA8Ipsc1uFy7ojyTr5LLiJk5QUREyoeRM+/ej1ALc3HOvfnS0qpupDu1vFN9FLooqf0/8XM2gUPkmQvZKc1DtyGf8ujR4c=
Message-ID: <6e7a378f0709041014m24448117s96d6f9b60fad7872@mail.gmail.com>
Date: Tue, 4 Sep 2007 19:14:20 +0200
From: "davide rossetti" <davide.rossetti@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: origin of __tmp1930643048 network device name: kernel-space or user-space
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

dear all,
I'm trying to track down a problem on a Sun V40Z server with 4 network
devices grabbing random ethX device names. now, trying to force the
device names to what I want, I got a __tmpXXXXX form of device name,
which I think is a half-configured device... but which piece of
software is to blame ??? kernel, udev, hotplug

it is a Fedora Core 6, fully updated (kernel-2.6.22.2-42.fc6
udev-095-17.fc6.x86_64)

ifconfig reports it as:
__tmp1930643048 Link encap:Ethernet  HWaddr 00:04:23:CA:BC:CB
          BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)
          Base address:0x3040 Memory:e70a0000-e70c0000

bond0     Link encap:Ethernet  HWaddr 00:04:23:CA:BC:CA
          inet addr:10.0.0.139  Bcast:10.0.255.255  Mask:255.255.0.0
          inet6 addr: fe80::204:23ff:feca:bcca/64 Scope:Link
          UP BROADCAST RUNNING MASTER MULTICAST  MTU:1500  Metric:1
          RX packets:7409 errors:0 dropped:0 overruns:0 frame:0
          TX packets:3855 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:1300152 (1.2 MiB)  TX bytes:509271 (497.3 KiB)

eth1      Link encap:Ethernet  HWaddr 00:04:23:CA:BC:CA
          inet6 addr: fe80::204:23ff:feca:bcca/64 Scope:Link
          UP BROADCAST RUNNING SLAVE MULTICAST  MTU:1500  Metric:1
          RX packets:7409 errors:0 dropped:0 overruns:0 frame:0
          TX packets:3855 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:1300152 (1.2 MiB)  TX bytes:509271 (497.3 KiB)
          Base address:0x3000 Memory:e7080000-e70a0000
....

help appreciated... so much :(

davide

--
davide.rossetti@gmail.com ICQ:290677265 SKYPE:d.rossetti


-- 
davide.rossetti@gmail.com ICQ:290677265 SKYPE:d.rossetti
