Return-Path: <linux-kernel-owner+w=401wt.eu-S1760319AbXGJQI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760319AbXGJQI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 12:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755100AbXGJQIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 12:08:19 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:41677 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535AbXGJQIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 12:08:19 -0400
Date: Tue, 10 Jul 2007 17:07:35 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Charles Shannon Hendrix <shannon@widomaker.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: BUG: kernel crash report, odd...
In-Reply-To: <20070709220848.GA6782@widomaker.com>
Message-ID: <Pine.LNX.4.64.0707101650390.4603@blonde.wat.veritas.com>
References: <20070709220848.GA6782@widomaker.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAAAmluYm94AHNoYW5ub25Ad2lkb21ha2VyLmNvbQBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnAA==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2007, Charles Shannon Hendrix wrote:
> 
> A system I was using a few minutes ago dumped this to the syslog:
> 
> Jul  9 17:50:38 daydream kernel: [76022.613000] BUG: unable to handle
> kernel NULL pointer dereference at virtual address 00000010
> Jul  9 17:50:38 daydream kernel: [76022.613000]  printing eip:
> Jul  9 17:50:38 daydream kernel: [76022.613000] c01ace66
> Jul  9 17:50:38 daydream kernel: [76022.613000] *pde = 00000000
> Jul  9 17:50:38 daydream kernel: [76022.613000] Oops: 0000 [#1]
> 
> There was no other information either before or after.

Something simple you can do, which I didn't see mentioned yet:
look up the entries before and after c01ace66 in that 2.6.20
kernel's System.map, then post the output of
objdump -d --start-address=0xbefore --stop-address=0xafter vmlinux
so people here can see the function name and the oopsing instruction
in its context.  May not help at all, but well worth trying.

Hugh
