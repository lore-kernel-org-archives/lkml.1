Return-Path: <linux-kernel-owner+w=401wt.eu-S1751789AbXLCXbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789AbXLCXbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 18:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbXLCXbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 18:31:12 -0500
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:34158 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751248AbXLCXbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 18:31:11 -0500
Message-ID: <475491CA.5050704@lwfinger.net>
Date: Mon, 03 Dec 2007 17:31:22 -0600
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: SoftMAC: Getting essid from req_essid
References: <2c0942db0711301506k7e154b76kc1fc99c189f68a3d@mail.gmail.com>
In-Reply-To: <2c0942db0711301506k7e154b76kc1fc99c189f68a3d@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ray Lee wrote:
> Hey there Larry, all,
> 
> git blame fingered commit id efe870f9 (from Larry) for adding a couple
> of fairly harmless looking messages to
> net/ieee80211/softmac/ieee80211softmac_wx.c . The problem is that one
> of them is clogging up my syslog at the tune of once a second or so
> ("SoftMAC: Getting essid from req_essid"), and rolling everything else
> out of my dmesg.
> 
> I just rebooted into 2.6.23-rc3+some, and after 36 minutes of uptime I
> already have:
> 
> $ dmesg | cut -d ']' -f2- | sort | uniq -c | sort -nr | head -3
> 
>    1047  SoftMAC: Getting essid from req_essid
>      38  SoftMAC: Getting essid from associate_essid
>      22  SoftMAC: Scanning finished: scanned 13 channels starting with channel 1
> 
> Is the message important for debugging, or can I make a patch to yank
> the silly thing?

Just turn off SoftMAC debugging.

Larry
