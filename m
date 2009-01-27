Return-Path: <linux-kernel-owner+w=401wt.eu-S1753516AbZA0KQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbZA0KQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 05:16:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbZA0KP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 05:15:57 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48571 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbZA0KP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 05:15:56 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] export get_task_comm()
Cc: kosaki.motohiro@jp.fujitsu.com, Alexey Dobriyan <adobriyan@gmail.com>,
       Kyle McMartin <kyle@infradead.org>,
       Christoph Bartelmus <lirc@bartelmus.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <20090127010035.18521a3b.akpm@linux-foundation.org>
References: <20090127084956.GA8416@x200.localdomain> <20090127010035.18521a3b.akpm@linux-foundation.org>
Message-Id: <20090127191413.D488.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 27 Jan 2009 19:15:52 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > It's worth a checkpatch rule, I guess: "direct access to
> > > task_struct.comm is racy - use get_task_comm()".
> > 
> > And majority of usages is some debugging printk where nobody cares if ->comm
> > corrupted.
> > 
> > Changelog says is useful for debugging. That's right, tsk->comm is useful
> > for debugging, not allocating temporary buffer + get_task_comm().
> > 
> > Some ->comm usages are for kernel threads which never change it, for starters.
> > 
> > current->comm is always safe, because, current is not executing prctl(2)! 
> 
> That's a good point.
> 
> > I'd say nothing should be done and, heavens forbid, adding this to checkpatch.pl.
> 
> hm, yeah, OK, I'll drop it.

Oh, I have to agree Alexey because he is always right ;)




