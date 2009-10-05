Return-Path: <linux-kernel-owner+w=401wt.eu-S1755005AbZJEWh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005AbZJEWh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 18:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754390AbZJEWh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 18:37:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49306 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271AbZJEWh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 18:37:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 15/21] kernel/power/: use pr_<level> and add pr_fmt(fmt)
Date: Tue, 6 Oct 2009 00:37:57 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc2-rjw; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Len Brown <len.brown@intel.com>, linux-pm@lists.linux-foundation.org
References: <cover.1254701151.git.joe@perches.com> <200910052143.37985.rjw@sisk.pl> <1254774687.1799.566.camel@Joe-Laptop.home>
In-Reply-To: <1254774687.1799.566.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200910060037.57546.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 October 2009, Joe Perches wrote:
> On Mon, 2009-10-05 at 21:43 +0200, Rafael J. Wysocki wrote:
> > On Monday 05 October 2009, Joe Perches wrote:
> > > Added #define pr_fmt(fmt) "PM: " fmt
> > > Converted printk(KERN_<level> to pr_<level>(
> > > Removed "PM: " prefix
> > > Added pr_fmt() to __initdata strings
> > 
> > Well, can you please tell me what actually is wrong with the current code?
> 
> Not much.  There were a couple of trivial corrections,
> but perhaps the changes add a bit more flexibility and
> regularity.
> 
> Effective trivial changes:
> 
> o Added KERN_CONT (pr_cont) to a couple of messages
> o Added "PM: " (pr_info) to an #ifdef'd message
> o Added "PM: " (pr_info) to a printk "Syncing filesystems ..."
>   in power/user.c

The patch as is conflicts with the changes I have queued up for 2.6.33
(they'll appear in linux-next after I've fixed all build issues, hopefully
tomorrow).  For one example, we're dropping swsusp.c altogether.

Also, I'm not a big fan of automatic conversions from printk() to
pr_something() other than pr_debug().

Thanks,
Rafael

