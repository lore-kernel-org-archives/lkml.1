Return-Path: <linux-kernel-owner+w=401wt.eu-S1758957AbYHaKxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758957AbYHaKxa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 06:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756990AbYHaKxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 06:53:21 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:52914 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756861AbYHaKxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 06:53:20 -0400
Date: Sun, 31 Aug 2008 10:48:32 +0200
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: Joe Korty <joe.korty@ccur.com>
Cc: Ayaz Abdulla <aabdulla@nvidia.com>, Jeff Garzik <jgarzik@redhat.com>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ETH] forcdeth: increase max_interrupt_work
Message-ID: <20080831084824.GB2698@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	Joe Korty <joe.korty@ccur.com>, Ayaz Abdulla <aabdulla@nvidia.com>,
	Jeff Garzik <jgarzik@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20080827142136.GA22262@tsunami.ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080827142136.GA22262@tsunami.ccur.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Korty wrote:
> Forcedeth: increase max_interrupt_work
> 
> This eliminates the following often-generated warning from
> my 64 bit Opteron SMP test stand:
> 
> 	eth0: too many iterations (6) in nv_nic_irq
> 
> According to the web, the problem is that the forcedeth
> driver has a too-low value for max_interrupt_work.
> Grepping the kernel I see that forcedeth has the second
> lowest value of all ethernet drivers (ie, 6).  Most are
> in the 20-40 range.  So this patch increases this a bit,
> from 6 to 15 (at 15 forcedeth becomes the driver with
> third-lowest max_interrupt_work value).

I'll add that I also see this warning now and then.

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
このメールは十割再利用されたビットで作られています。
