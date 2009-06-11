Return-Path: <linux-kernel-owner+w=401wt.eu-S1761861AbZFKCYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761861AbZFKCYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 22:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761966AbZFKCXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 22:23:51 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60650 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761868AbZFKCXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 22:23:50 -0400
Date: Thu, 11 Jun 2009 11:21:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "Trenton D. Adams" <trenton.d.adams@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Macbook 4G only see 3G
Message-Id: <20090611112159.9be7477f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <86802c440906101754g496da536t48ade9b1b220449a@mail.gmail.com>
References: <9b1675090906101747u4ab8cc89t764ba80b4eb3dcb2@mail.gmail.com>
	<86802c440906101754g496da536t48ade9b1b220449a@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Jun 2009 17:54:39 -0700
Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> On Wed, Jun 10, 2009 at 5:47 PM, Trenton D.
> Adams<trenton.d.adams@gmail.com> wrote:
> > Hi Guys,
> >
> > Has anyone been doing any development in the area of enabling 4G for
> > any PC that doesn't have an option in the BIOS?  The Mac OS X sees the
> > full 4G, but Linux does not.
> >
> > tdamac ~ # uname -a
> > Linux tdamac 2.6.30-rc7-dirty #3 SMP Fri Jun 5 21:24:29 MDT 2009
> > x86_64 Intel(R) Core(TM)2 CPU T7400 @ 2.16GHz GenuineIntel GNU/Linux
> 
> boot log?
> 
I bet you should set CONFIG_HIGHMEM64G or use x86-64 kernel because of
1G of memory hole somewhere below 4G.

Thanks,
-Kame

> YH
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

