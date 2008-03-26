Return-Path: <linux-kernel-owner+w=401wt.eu-S1756659AbYCZJUD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659AbYCZJUD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 05:20:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614AbYCZJTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 05:19:52 -0400
Received: from public.bindows.net ([66.135.40.169]:57539 "EHLO
	public.bindows.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbYCZJTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 05:19:51 -0400
Message-ID: <47EA152C.6000008@better.se>
Date: Wed, 26 Mar 2008 10:19:40 +0100
From: Marcus Better <marcus@better.se>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 10327] New: keyboard stops responding after
 "ifdown eth0"
References: <bug-10327-10286@http.bugzilla.kernel.org/>	<20080325143941.300d415f.akpm@linux-foundation.org>	<47E9721C.2000306@better.se>	<47E99258.3060005@s5r6.in-berlin.de> <20080325171608.509f4ca7.akpm@linux-foundation.org>
In-Reply-To: <20080325171608.509f4ca7.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> 	( sleep 10 ; echo t > /proc/sysrq-trigger ) &
> 	ifdown eth0
> 
> 
> - See if the sysrq-t output made it to /var/log/messages

No, not a word. It hung after printing this:

...
DHCPRELEASE ...
send_packet: Network is unreachable
send_packet: please consult README ...
sky2 eth0: disabling interface
~# sky2 eth0: enabling interface

I'm running ifplugd, but this time there was no network cable connected. 
Also ran from virtual console this time, the keyboard locked up like before.

SysRq keys work, so I could do sysrq-s, sysrq-b. Also pressed sysrq-t 
before rebooting.

Any use trying netconsole? Can I run it over the wireless interface?

Marcus
