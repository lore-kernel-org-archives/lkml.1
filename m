Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbYEDXf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbYEDXf3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 19:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbYEDXfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 19:35:21 -0400
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:58125 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752627AbYEDXfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 19:35:20 -0400
Message-ID: <481E4833.3050304@lwfinger.net>
Date: Sun, 04 May 2008 18:35:15 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: markknecht@gmail.com
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24.4 Sonics Silicon Backplane problems in dmesg
References: <481E4657.3080707@lwfinger.net>
In-Reply-To: <481E4657.3080707@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Finger wrote:
> I'm attempting to bring up a Compaq F752US laptop running Gentoo. The
> kernel.org 2.6.24.4, Gentoo Vanilla-sources and 2.6.24-gentoo-r4
> kernels all fail to boot without selecting the 'noapic' option on the
> kernel command line. If I add noapic irqpoll the machine does boot but
> I see this problem for all 3 kernels:
> 
> Is this possibly caused by having to choose the noapic irqpoll options?
> 
> <SNIP>
> WARNING: at drivers/ssb/main.c:883 ssb_tmslow_reject_bitmask()
> Pid: 1, comm: swapper Not tainted 2.6.24-gentoo-r4 #4
> [<c0375e3f>] ssb_tmslow_reject_bitmask+0x4b/0x56
> [<c0376504>] ssb_device_is_enabled+0x9/0x2d

The warning above is caused by the configuration of the device below. I found
and fixed this problem several months ago, but after the 2.6.24 window closed.

> 03:00.0 Network controller: Broadcom Corporation BCM94311MCG wlan
> mini-PCI (rev 02)

The problem is fixed in the wireless-testing.git tree, and in mainline 
2.6.25. It is unlikely that it is causing the boot problem; however that 
could be checked by trying 2.6.25.


Larry
