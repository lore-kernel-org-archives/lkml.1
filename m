Return-Path: <linux-kernel-owner+w=401wt.eu-S1759520AbYBZL0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759520AbYBZL0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 06:26:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752736AbYBZL0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 06:26:39 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44258 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbYBZL0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 06:26:37 -0500
Date: Tue, 26 Feb 2008 20:25:13 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: 2.6.25-rc2-mm1 - boot hangs on ia64
Cc: kosaki.motohiro@jp.fujitsu.com, linux-ia64 <linux-ia64@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@redhat.com>,
       Bob Picco <bob.picco@hp.com>, Eric Whitney <eric.whitney@hp.com>
In-Reply-To: <1203955017.5046.29.camel@localhost>
References: <1203955017.5046.29.camel@localhost>
Message-Id: <20080226202308.FF40.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Fujitsu machine can't boot too.
my bisect indicate git-sched.patch cause regression too.

Thanks.

> 25-rc2-mm1 is hanging early in boot on my HP ia64 numa platform.  I saw
> the "Strange hang on ia64 with CONFIG_PRINTK_TIME=y" thread on lkml:  
> 
> 	http://marc.info/?t=120288396800001&r=1&w=4
> 
> However, my config does not include PRINTK_TIME=y.  In fact, hang occurs
> with ia64 defconfig as well--right after the "Loading...initrd...done"
> message.  2.6.25-rc2 boots OK.
> 
> Bisecting the broken-out series appears to indict 'git-sched.patch'.  I
> went ahead and added Ingo's patch, discussed in the "strange hang"
> thread, even tho' I hadn't enabled printk timestamps.  No effect.
> 
> Anyone else seeing this?



