Return-Path: <linux-kernel-owner+w=401wt.eu-S1758102AbYBRBVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102AbYBRBVk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 20:21:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750992AbYBRBV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 20:21:29 -0500
Received: from fbr02.csee.onr.siteprotect.com ([64.26.60.146]:46137 "EHLO
	fbr02.csee.onr.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751763AbYBRBV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 20:21:28 -0500
X-Greylist: delayed 1195 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Feb 2008 20:21:28 EST
Date: Sun, 17 Feb 2008 20:15:09 -0500 (EST)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: linux-kernel@vger.kernel.org
Subject: finding per-process hw interrupt counts
Message-ID: <Pine.LNX.4.64.0802171929480.5572@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

is there a way to find out how many times a userspace program is forced to 
context switch due to a hardware interrupt?

The reason for this:
I am measuring the retired instruction count of programs using performance 
counters (perfmon2 patchset), and trying to find out where the 
descrepancies compe from.

On x86, it seems to be:

   reported_count = expected_count + 1*major_pagefaults + \
                    1*hardware_interrupts + known_errata + 1

I can get the pagefault info from getrusage().  The hardware_interrupts 
count is my best guess at what is causing the rest, based on the LOC
field in /proc/interrupts.  That's not per-process though.

Is this info available?  If not, is it possible to patch the kernel to 
make it so?

Thanks for any help

Vince
vince@deater.net
