Return-Path: <linux-kernel-owner+w=401wt.eu-S1946010AbXECUbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946010AbXECUbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 16:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946072AbXECUbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 16:31:45 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:55979 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946010AbXECUbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 16:31:44 -0400
Date: Thu, 3 May 2007 16:31:43 -0400
To: linux-kernel@vger.kernel.org
Subject: Strange soft lockup detected message
Message-ID: <20070503203143.GA8753@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have had this happen a few times recently and was wondering if anyone
has an idea what could be going on:

BUG: soft lockup detected on CPU#0!
 [<c0103fc4>] dump_stack+0x24/0x30
 [<c013d71e>] softlockup_tick+0x7e/0xc0
 [<c011eb23>] update_process_times+0x33/0x80
 [<c01062c9>] timer_interrupt+0x39/0x80
 [<c013daad>] handle_IRQ_event+0x3d/0x70
 [<c013de09>] __do_IRQ+0xa9/0x150
 [<c0104e55>] do_IRQ+0x25/0x60
 [<c010313a>] common_interrupt+0x1a/0x20
 [<d084e00c>] pcnet32_dwio_read_csr+0xc/0x20 [pcnet32]
 [<d084e9d2>] pcnet32_interrupt+0x42/0x2b0 [pcnet32]
 [<c013daad>] handle_IRQ_event+0x3d/0x70
 [<c013de09>] __do_IRQ+0xa9/0x150
 [<c0104e55>] do_IRQ+0x25/0x60
 [<c010313a>] common_interrupt+0x1a/0x20
 [<c013da88>] handle_IRQ_event+0x18/0x70
 [<c013de09>] __do_IRQ+0xa9/0x150
 [<c0104e55>] do_IRQ+0x25/0x60
 [<c010313a>] common_interrupt+0x1a/0x20
 [<00005791>] 0x5791

This is on a system running a Geode LX at 500MHz, using 2.6.18 based
kernel (specifically a slightly modified debian 4.0 Etch kernel).

I am really wondering where do I go looking for the cause of this.  The
same kernel running on a Geode SC1200 (GX1) does not appear to do this.

If I knew what the error meant I would have a better idea how to debug
it and fix it.

--
Len Sorensen
