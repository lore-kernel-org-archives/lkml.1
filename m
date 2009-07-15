Return-Path: <linux-kernel-owner+w=401wt.eu-S932097AbZGOPZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097AbZGOPZc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 11:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755397AbZGOPZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 11:25:31 -0400
Received: from sh.osrg.net ([192.16.179.4]:57707 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755391AbZGOPZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 11:25:30 -0400
Date: Thu, 16 Jul 2009 00:25:26 +0900 (JST)
Message-Id: <20090716.002526.93465395.ryusuke@osrg.net>
To: leon.woestenberg@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Why does NILFS2 hide under Miscellaneous filesystems?
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <c384c5ea0907150411i3523e751tfdf469acce0b2c55@mail.gmail.com>
References: <c384c5ea0907150411i3523e751tfdf469acce0b2c55@mail.gmail.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 16 Jul 2009 00:25:26 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
On Wed, 15 Jul 2009 13:11:21 +0200, Leon Woestenberg wrote:
> Hello,
> 
> just wondering, any reasons why NILFS2 is one of the miscellaneous
> filesystems and, for example, btrfs, is not in Kconfig?
> 
> Regards,
> -- 
> Leon

I heard this question from several people, and now I feel I should
have put nilfs outside the misc filesystem category.

Actually, nilfs is NOT a filesystem came from other operating system,
but a filesystem created purely for Linux.  Nor is it a flash
filesystem but that for generic block devices.

So, If nobody objects, I would like to queue a patch to move it
outside the misc category.  Anybody comments?

Thanks,
Ryusuke Konishi
