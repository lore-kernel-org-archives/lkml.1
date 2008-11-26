Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbYKZOTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbYKZOTg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 09:19:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbYKZOTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 09:19:18 -0500
Received: from vena.lwn.net ([206.168.112.25]:49316 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753155AbYKZOTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 09:19:17 -0500
Date: Wed, 26 Nov 2008 07:19:15 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: LKML <linux-kernel@vger.kernel.org>
Subject: ext3: unwelcome journal abort
Message-ID: <20081126071915.0decaf2c@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Twice now I've gotten the following with 2.6.28-rc3:

Nov 26 00:15:49 bike kernel: [282457.819704] __log_wait_for_space: no transactions
Nov 26 00:15:49 bike kernel: [282457.819707] Aborting journal on device sda6.
Nov 26 00:15:49 bike kernel: [282457.820824] ext3_abort called.
Nov 26 00:15:49 bike kernel: [282457.820829] EXT3-fs error (device sda6): ext3_journal_start_sb: Detected aborted journal
Nov 26 00:15:49 bike kernel: [282457.820832] Remounting filesystem read-only
Nov 26 00:15:49 bike kernel: [282457.905000] __journal_remove_journal_head: freeing b_committed_data
Nov 26 00:15:49 bike kernel: [282457.905010] __journal_remove_journal_head: freeing b_committed_data
Nov 26 00:15:49 bike kernel: [282457.905273] __journal_remove_journal_head: freeing b_committed_data
Nov 26 00:15:49 bike kernel: [282457.905276] __journal_remove_journal_head: freeing b_committed_data
Nov 26 00:15:49 bike kernel: [282457.905288] __journal_remove_journal_head: freeing b_committed_data
Nov 26 00:15:49 bike kernel: [282457.905298] __journal_remove_journal_head: freeing b_committed_data

Both times, it has happened in the middle of the night; I just find
my /home partition mounted read-only in the morning.  And that, in
turn, makes keeping up with linux-kernel really hard.

I'm pulling the system up to -rc6 now, will yell if it happens again.
Is there anything else I can be looking at in the mean time?

Thanks,

jon
