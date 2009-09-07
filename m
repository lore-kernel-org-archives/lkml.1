Return-Path: <linux-kernel-owner+w=401wt.eu-S1753243AbZIGLsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbZIGLsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 07:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbZIGLsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 07:48:40 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44810 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbZIGLsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 07:48:39 -0400
Date: Mon, 7 Sep 2009 12:48:15 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stanislav Brabec <utx@penguin.cz>
Cc: Pavel Machek <pavel@ucw.cz>, Eric Miao <eric.y.miao@gmail.com>,
       Richard Purdie <rpurdie@rpsys.net>, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.miao@marvell.com,
       Andrea Adami <andrea.adami@gmail.com>
Subject: Re: Zaurus suspend saga
Message-ID: <20090907114815.GA23361@n2100.arm.linux.org.uk>
References: <20090906052653.GB1324@ucw.cz> <1252276145.17852.15.camel@dax.rpnet.com> <f17812d70909061806y651c390w1faa5364f0fb6ddc@mail.gmail.com> <20090907110307.GK23450@elf.ucw.cz> <1252323270.14911.20.camel@hammer.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252323270.14911.20.camel@hammer.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 07, 2009 at 01:34:29PM +0200, Stanislav Brabec wrote:
> Serial after resume. (regression)

If you pass no_console_suspend, the console serial port doesn't have its
state saved and restored upon resume.  This is something I pointed out
while I was serial maintainer and got ignored...

I think you'll find that it'll work if you don't pass no_console_suspend,
though you won't get the messages between the console itself being
suspended and subsequently resumed.
