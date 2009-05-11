Return-Path: <linux-kernel-owner+w=401wt.eu-S1756017AbZEKREj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017AbZEKREj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 13:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758461AbZEKRCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 13:02:33 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:20973 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758435AbZEKRCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 13:02:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=BCUkgGciGEk/VPSyokjVwAWTqZWXw6SRixpy9K1g4yepCK2hfbip8GmpNnMB3dbcUb
         DhCEOThSwnIXOHwxVrXWvVs/Izz+1OpDMq4uL5ajLsDTM9a60N9IEMSvipfbDb7QiaHu
         i9P3jG8gD8ZVQVuxZ9RVkBi1yGSAzVvslXCc4=
MIME-Version: 1.0
Date: Mon, 11 May 2009 10:02:32 -0700
Message-ID: <dd18b0c30905111002y4aeb2033ma2fbb2730f5acdaf@mail.gmail.com>
Subject: ath9k seems to be broken on 2.6.30-rc4 with a macbook pro
From: Justin Mattock <justinmattock@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been trying to diagnose an issue
with 2.6.30-rc4. At first thinking it
was not the kernel, but the network manager
(in my case I use wicd).
with 2.6.29-rc8 the system starts up,
connects no problem.
but as soon as I load 2.6.30-rc4
I get limited connection to none.
in dmesg I see:

[   36.337419] wlan0: direct probe to AP 00:1e:2a:00:67:f0 try 1
[   36.530106] wlan0: direct probe to AP 00:1e:2a:00:67:f0 try 2
[   36.730100] wlan0: direct probe to AP 00:1e:2a:00:67:f0 try 3
[   36.930101] wlan0: direct probe to AP 00:1e:2a:00:67:f0 timed out
[   44.421728] wlan0: direct probe to AP 00:1e:2a:00:67:f0 try 1
[   44.620080] wlan0: direct probe to AP 00:1e:2a:00:67:f0 try 2
[   44.820080] wlan0: direct probe to AP 00:1e:2a:00:67:f0 try 3
[   45.020076] wlan0: direct probe to AP 00:1e:2a:00:67:f0 timed out

The type of encryption used is just
a standard WEP key(no WPA).

has this been resolved already?

Also I'm noticing(but not that big of a deal)
if I set in sysctl.conf:

net.ipv4.conf.all.arp_ignore=8
net.ipv4.conf.wlan0.arp_ignore=8
net.ipv4.conf.wmaster0.arp_ignore=8
net.ipv4.conf.lo.arp_ignore=8
net.ipv4.conf.all.arp_announce=2
net.ipv4.conf.wlan0.arp_announce=2
net.ipv4.conf.wmaster0.arp_announce=2
net.ipv4.conf.lo.arp_announce=2

watching a movie on hulu, about 15/20 minuets
into enjoyment, hulu craps out(starts re-buffering)
then re initializes after about 30 secs later.
but if I comment those out(set back to default)
hulu will run fine.

-- 
Justin P. Mattock
