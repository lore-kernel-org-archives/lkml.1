Return-Path: <linux-kernel-owner+w=401wt.eu-S1756010AbYGUOQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbYGUOQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 10:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753117AbYGUOQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 10:16:05 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:42643 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbYGUOQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 10:16:04 -0400
Message-ID: <488499FD.5090300@s5r6.in-berlin.de>
Date: Mon, 21 Jul 2008 16:15:25 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
References: <20080720.104411.81744468.davem@davemloft.net> <20080721135024.GA18320@elte.hu>
In-Reply-To: <20080721135024.GA18320@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> I'm wondering, couldnt we warn about the removed pci express support via 
> the kernel log? Some simple printk. (Perhaps also with a default-off 
> .config option that shuts up this warning for users who intentionally 
> boot E1000=y without e1000e support.)

e1000_init_module() already has two printk()s.  A third unconditional
one won't hurt a lot.  The first two could also be joined.
-- 
Stefan Richter
-=====-==--- -=== =-=-=
http://arcgraph.de/sr/
