Return-Path: <linux-kernel-owner+w=401wt.eu-S1757511AbXE0Tpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbXE0Tpy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 15:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbXE0Tpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 15:45:43 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:42904
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbXE0Tpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 15:45:42 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Maximilian Engelhardt <maxi@daemonizer.de>
Subject: Re: b44: regression in 2.6.22 (resend)
Date: Sun, 27 May 2007 21:45:00 +0200
User-Agent: KMail/1.9.6
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-wireless" <linux-wireless@vger.kernel.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Jeff Garzik <jgarzik@pobox.com>, Gary Zambrano <zambrano@broadcom.com>,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <20070525172431.60affaca@freepuppy> <200705261901.18110.mb@bu3sch.de> <200705272125.25506.maxi@daemonizer.de>
In-Reply-To: <200705272125.25506.maxi@daemonizer.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705272145.00796.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 May 2007 21:25:17 Maximilian Engelhardt wrote:
> 2.6.22-rc3:
> 
> [  5] local 192.168.1.2 port 46557 connected with 192.168.1.1 port 5001
> [  5]  0.0-60.4 sec  58.9 MBytes  8.18 Mbits/sec
> [  4] local 192.168.1.2 port 5001 connected with 192.168.1.1 port 51633
> [  4]  0.0-63.1 sec  7.27 MBytes    967 Kbits/sec

Why do we have two different measurements here? Is one TX and one RX?
Which one?

> koala:~# ping -c10 192.168.1.1
> PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
> 64 bytes from 192.168.1.1: icmp_seq=1 ttl=64 time=0.243 ms
> 64 bytes from 192.168.1.1: icmp_seq=2 ttl=64 time=0.234 ms
> 64 bytes from 192.168.1.1: icmp_seq=3 ttl=64 time=0.238 ms
> 64 bytes from 192.168.1.1: icmp_seq=4 ttl=64 time=0.235 ms
> 64 bytes from 192.168.1.1: icmp_seq=5 ttl=64 time=0.230 ms
> 64 bytes from 192.168.1.1: icmp_seq=6 ttl=64 time=0.317 ms
> 64 bytes from 192.168.1.1: icmp_seq=7 ttl=64 time=0.232 ms
> 64 bytes from 192.168.1.1: icmp_seq=8 ttl=64 time=0.232 ms
> 64 bytes from 192.168.1.1: icmp_seq=9 ttl=64 time=0.228 ms
> 64 bytes from 192.168.1.1: icmp_seq=10 ttl=64 time=0.238 ms
> 
> --- 192.168.1.1 ping statistics ---
> 10 packets transmitted, 10 received, 0% packet loss, time 8997ms
> rtt min/avg/max/mdev = 0.228/0.242/0.317/0.031 ms
> 
> System responsiveness was the same as with 2.6.21.1.
> 
> wget got 11.23M/s, again same as 2.6.21.1.
> 
> 
> 2.6.22-rc2-mm1:
> 
> [  5] local 192.168.1.2 port 42198 connected with 192.168.1.1 port 5001
> [  5]  0.0-60.1 sec    402 MBytes  56.1 Mbits/sec
> [  4] local 192.168.1.2 port 5001 connected with 192.168.1.1 port 48598
> [  4]  0.0-63.0 sec    177 MBytes  23.6 Mbits/sec

So with -mm (with ssb) you actually get better performace
then with plain 2.6.22-rc3?

Can you elaborate a bit more about what you get an what you expect
on which kernel?

-- 
Greetings Michael.
