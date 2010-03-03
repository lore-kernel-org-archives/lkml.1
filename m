Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab0CCQpR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 11:45:17 -0500
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196]:61288 "EHLO
	mta1.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588Ab0CCQpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 11:45:12 -0500
Date: Wed, 03 Mar 2010 11:45:18 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: Regression - panic booting 2.6.33- 04130-gc9658bf
To: linux-kernel@vger.kernel.org
Message-id: <4B8E921E.7050009@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.7)
 Gecko/20100111 Lightning/1.0b2pre Thunderbird/3.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't have time to bisect today - 2.6.33-02468-g98b3188 booted yesterday 
with commit 9f7cdbc reverted.

I grabbed the panic with a cell camera - not much, so typing it here:

Kernel panic - not syncing: VFS: Unable to mount root fs ...
Pid: 1, comm: swapper Tainted: G      W 2.6.33-04130 ... etc
Call Trace:
[<ffffffff815333d9>] panic+0x78/0x145
[<ffffffff81b2e241>] mount_block_root+0x1e7/0x29b
[<ffffffff81002930>] ? trace_kmalloc+0x1f0/0x8c0
[<ffffffff81b2e34b>] mount_root+0x56/0x5a
[<ffffffff81b2e4bf>] prepare_namespace+0x170/0x19d
[<ffffffff81b2d77c>] kernel_init+0x1b1/0x1c1
[<ffffffff8100bf24>] kernel_thread_helper+0x4/0x10
[<ffffffff81536b7d>] ? restore_args+0x0/0x30
[<ffffffff81b2d5cb>] ? kernel_init+0x0/0x1c1
[<ffffffff8100bf20>] ? kernel_thread_helper+0x0/0x10

