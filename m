Return-Path: <linux-kernel-owner+w=401wt.eu-S1763645AbXESIYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763645AbXESIYB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 04:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755143AbXESIXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 04:23:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38219 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403AbXESIXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 04:23:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: why only one use of "create_freezeable_workqueue"?
Date: Sat, 19 May 2007 10:29:04 +0200
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
References: <Pine.LNX.4.64.0705190003410.16887@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0705190003410.16887@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705191029.05152.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 19 May 2007 06:09, Robert P. J. Day wrote:
> 
>   hoping to avoid the madness following my earlier, innocuous question
> about the lonely, defconfig'ed module scsi_wait_scan.ko, i'm curious
> about why there is, in the entire tree, just one invocation of
> "create_freezeable_workqueue":
> 
> $ grep -rw create_freezeable_workqueue *
> drivers/misc/tifm_core.c:       workqueue = create_freezeable_workqueue("tifm");
> include/linux/workqueue.h:#define create_freezeable_workqueue(name) __create_workqueue((name), 1, 1)
> $
> 
>   not that there's anything wrong with that, but i'm just curious as
> to why there's only one application of that feature in the whole tree.

Because the feature has limitted functionality (signlethread workqueues only),
needs some more work and the use of it is discouraged (for now).

Greetings,
Rafael
