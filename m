Return-Path: <linux-kernel-owner+w=401wt.eu-S1758884AbZIPMZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758884AbZIPMZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 08:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758873AbZIPMZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 08:25:42 -0400
Received: from ns.penguin.cz ([84.21.108.25]:34352 "EHLO ns.penguin.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758859AbZIPMZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 08:25:41 -0400
Subject: Re: Zaurus suspend saga
From: Stanislav Brabec <utx@penguin.cz>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Pavel Machek <pavel@ucw.cz>, Eric Miao <eric.y.miao@gmail.com>,
       Richard Purdie <rpurdie@rpsys.net>, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.miao@marvell.com,
       Andrea Adami <andrea.adami@gmail.com>
In-Reply-To: <20090907114815.GA23361@n2100.arm.linux.org.uk>
References: <20090906052653.GB1324@ucw.cz>
	 <1252276145.17852.15.camel@dax.rpnet.com>
	 <f17812d70909061806y651c390w1faa5364f0fb6ddc@mail.gmail.com>
	 <20090907110307.GK23450@elf.ucw.cz>
	 <1252323270.14911.20.camel@hammer.suse.cz>
	 <20090907114815.GA23361@n2100.arm.linux.org.uk>
Content-Type: text/plain
Date: Wed, 16 Sep 2009 14:25:40 +0200
Message-Id: <1253103940.5902.2.camel@hammer.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux wrote:
> On Mon, Sep 07, 2009 at 01:34:29PM +0200, Stanislav Brabec wrote:
> > Serial after resume. (regression)
> 
> If you pass no_console_suspend, the console serial port doesn't have its
> state saved and restored upon resume.  This is something I pointed out
> while I was serial maintainer and got ignored...
> 
> I think you'll find that it'll work if you don't pass no_console_suspend,
> though you won't get the messages between the console itself being
> suspended and subsequently resumed.

I sent a possible fix of this problem to LKML:
http://lkml.org/lkml/2009/9/15/206

-- 
Stanislav Brabec
http://www.penguin.cz/~utx

