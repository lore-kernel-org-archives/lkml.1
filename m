Return-Path: <linux-kernel-owner+w=401wt.eu-S1752043AbZI0SQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbZI0SQT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 14:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbZI0SQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 14:16:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60774 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbZI0SQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 14:16:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [2.6.31-git17] WARNING: at kernel/hrtimer.c:648 hres_timers_resume+0x40/0x50()/WARNING: at drivers/base/sys.c:353 __sysdev_resume+0xc3/0xe0()
Date: Sun, 27 Sep 2009 20:17:43 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: Yong Zhang <yong.zhang0@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       clemens@ladisch.de, venkatesh.pallipadi@intel.com, gregkh@suse.de,
       zambrano@broadcom.com, davem@davemloft.net, netdev@vger.kernel.org
References: <8db1092f0909270105x4b49daf8k268e453d2379020c@mail.gmail.com> <2674af740909270749u339671a1ia81d5736eeb750fa@mail.gmail.com> <8db1092f0909270916k79d0c369ub93b5e8ddf66c979@mail.gmail.com>
In-Reply-To: <8db1092f0909270916k79d0c369ub93b5e8ddf66c979@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200909272017.43348.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 September 2009, Maciej Rutecki wrote:
> 2009/9/27 Yong Zhang <yong.zhang0@gmail.com>:
> >
> > It seem this is cause by b44 dirver. Can you give a try?
> >
> > From 05ee2f22a7ea065e05bf8b5294d222a3700d2cc8 Mon Sep 17 00:00:00 2001
> > From: Yong Zhang <yong.zhang0@gmail.com>
> > Date: Sun, 27 Sep 2009 22:42:41 +0800
> > Subject: [PATCH] net/b44: keep irq state at suspend_resume
> >
> > suspend() and resume() assume irq is disabled. So keep the irq
> > state when do this.
> 
> Remove previous patch, add it to clean 2.6.31-git17. It doesn't help.

It couldn't.  The problem is elswhere, but I haven't found it yet.

Thanks,
Rafael
