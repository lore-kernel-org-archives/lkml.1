Return-Path: <linux-kernel-owner+w=401wt.eu-S1752686AbYKPIXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbYKPIXj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 03:23:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbYKPIXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 03:23:32 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36934
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751274AbYKPIXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 03:23:31 -0500
Date: Sun, 16 Nov 2008 00:23:31 -0800 (PST)
Message-Id: <20081116.002331.203400963.davem@davemloft.net>
To: arjan@infradead.org
Cc: laijs@cn.fujitsu.com, akpm@linux-foundation.org, menage@google.com,
       kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com,
       jens.axboe@oracle.com, jack@suse.cz, jes@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] mm: introduce simple_malloc()/simple_free()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081115215309.7f29c33c@infradead.org>
References: <20081115210334.3870cdf6.akpm@linux-foundation.org>
	<491FB107.6050703@cn.fujitsu.com>
	<20081115215309.7f29c33c@infradead.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@infradead.org>
Date: Sat, 15 Nov 2008 21:53:09 -0800

> On Sun, 16 Nov 2008 13:35:03 +0800
> Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> 
> > vmalloc() is not good for performance and increasing fragment.
> > but vmalloc() is need for some subsystems' alternative malloc,
> > like cgroup's tasks file and other subsystems(about 20 subsystems).
> 
> actually what you are pointing out is that these areas need improvement
> to not need such huge blocks of memory... but only a series of smaller
> blocks instead.

Like the IPSEC policy and state hash tables when hundreds of thousands
of rules become active?

You have to be joking.
