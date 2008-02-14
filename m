Return-Path: <linux-kernel-owner+w=401wt.eu-S1764739AbYBNDro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764739AbYBNDro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 22:47:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756644AbYBNDrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 22:47:35 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:21426 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925AbYBNDre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 22:47:34 -0500
To: "Tony Luck" <tony.luck@intel.com>
Cc: "David Miller" <davem@davemloft.net>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: Strange hang on ia64 with CONFIG_PRINTK_TIME=y
X-Message-Flag: Warning: May contain useful information
References: <20080213125725.GC6344@elte.hu>
	<20080213.050340.64342037.davem@davemloft.net>
	<12c511ca0802131659u6e4407d9w96148fe72d6e11d7@mail.gmail.com>
	<20080213.170452.68851396.davem@davemloft.net>
	<12c511ca0802131933g6aaaec9cidbfbfcac6f394c63@mail.gmail.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 13 Feb 2008 19:47:26 -0800
In-Reply-To: <12c511ca0802131933g6aaaec9cidbfbfcac6f394c63@mail.gmail.com> (Tony Luck's message of "Wed, 13 Feb 2008 19:33:42 -0800")
Message-ID: <adaprv0rygh.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Feb 2008 03:47:28.0766 (UTC) FILETIME=[51F029E0:01C86EBC]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > I'll take a closer look at what is needed tomorrow.

Hi Tony,

Just curious -- can you reproduce the same problem with
CONFIG_PRINTK_TIME as I'm seeing?  If not I'm happy to test anything
you want to try.

The strange thing is that Ingo's patch to make cpu_clock() a NOP until
after sched_init() didn't fix things for me...

 - R.

