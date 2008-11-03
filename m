Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbYKCFKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbYKCFKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 00:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750925AbYKCFKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 00:10:31 -0500
Received: from cnmailgate04.alcatel-sbell.com.cn ([211.144.215.47]:59538 "EHLO
	cnshjsmin03.cn.alcatel-lucent.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750920AbYKCFKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 00:10:31 -0500
X-AuditID: ac189297-adf87bb000000fe5-9c-490e8793009a
Message-ID: <490E87A8.8020600@alcatel-lucent.com>
Date: Mon, 03 Nov 2008 13:10:00 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: peter360 <peter360@fastmail.us>
CC: linux-kernel@vger.kernel.org
Subject: Re: which .ko file?
References: <20297391.post@talk.nabble.com>
In-Reply-To: <20297391.post@talk.nabble.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Nov 2008 05:09:44.0812 (UTC) FILETIME=[62B142C0:01C93D72]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

peter360 wrote:
> Hi,
>
> How do I determine the .ko file used for a certain kernel module in a
> running kernel?  For example, on my dell laptop I see
> $ lsmod | grep 3945
> ipw3945               230952  1 
> ieee80211              65161  1 ipw3945
>
> $ modinfo ipw3945
> modinfo: could not open /lib/modules/2.6.18-92.1.1.el5/extra/ipw3945.ko: No
> such file or directory
>
> $ locate ipw3945.ko
> /lib/modules/2.6.18-52.el5/weak-updates/ipw3945.ko
> /lib/modules/2.6.18-52.el5/weak-updates/ipw3945/ipw3945.ko
> /lib/modules/2.6.18-8.1.4.el5/extra/ipw3945/ipw3945.ko
> /lib/modules/2.6.18-92.1.1.el5/weak-updates/ipw3945/ipw3945.ko
> /lib/modules/2.6.18-92.1.10.el5/weak-updates/ipw3945.ko
> /lib/modules/2.6.18-92.1.10.el5/weak-updates/ipw3945/ipw3945.ko
>
> $ uname -a
> Linux mylaptop 2.6.18-92.1.1.el5 #1 SMP Thu May 22 09:01:47 EDT 2008 x86_64
> x86_64 x86_64 GNU/Linux
>
> How do I find out which ipw3945.ko file was actually loaded into the kernel?
> thanks!
>   
I think it's 
/lib/modules/2.6.18-92.1.1.el5/weak-updates/ipw3945/ipw3945.ko, which
matches your kernel version, right? You could remove it to another 
directory instead
of current used /lib/modules/2.6.18-92.1.1.el5/, then try "lsmod | grep 
3495". If you
still could see it, then my guess is wrong. Otherwise, I'm correct.
