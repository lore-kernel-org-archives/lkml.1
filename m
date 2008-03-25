Return-Path: <linux-kernel-owner+w=401wt.eu-S1756162AbYCYDH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbYCYDH1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 23:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754411AbYCYDHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 23:07:18 -0400
Received: from mail9.dslextreme.com ([66.51.199.94]:59507 "HELO
	mail9.dslextreme.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754188AbYCYDHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 23:07:17 -0400
Message-ID: <47E86C60.5040706@gawab.com>
Date: Mon, 24 Mar 2008 20:07:12 -0700
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080228)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [Regression: 2.6.25-rc5: Blank Screen: Intel 945]
References: <47D828BB.2000702@gawab.com> <200803181417.34320.jbarnes@virtuousgeek.org> <47E1A3F1.3020004@gawab.com> <200803191648.59400.jbarnes@virtuousgeek.org>
In-Reply-To: <200803191648.59400.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> Good luck with the upgrade...

Well, the upgrade went ok, and compiling the reg_dumper using the libpciaccess .deb from Bryce worked.
Then I tried to add to the boot scripts a call to reg_dumper...
...To make a long story short...
I somehow killed my boot scripts! Anyways, I did a fresh reinstall of Ubuntu 8.4 Beta.

I'm still getting the blank screen problem with the 2.6.25-rc6 kernel,
so I guess it wasn't a Ubuntu software problem (or I hope not, because that could be really hard to find).

What I did was created a script that took a reg_dump every 6 secs for 1 min.
I made that as rc2.d/S01regdump so it should've been the very first thing called.
So, I hope there's enough "data points" to see what's happening.

Reg Dump Information
	http://jdserver.homelinux.org/linux/reg_dump.tar.bz2
Detailed System Information
	http://jdserver.homelinux.org/linux/sysinfo-2.6.25-rc6
Kernel Config
	http://jdserver.homelinux.org/linux/config-2.6.25-rc6

Hope that can help find the problem. If you need me to test anything else I'll try.

Justin

