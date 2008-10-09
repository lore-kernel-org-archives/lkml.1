Return-Path: <linux-kernel-owner+w=401wt.eu-S1756904AbYJIVSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904AbYJIVSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 17:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbYJIVSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 17:18:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58409 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753348AbYJIVSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 17:18:05 -0400
Date: Thu, 9 Oct 2008 14:17:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: gregkh@suse.de, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, agruen@suse.de, jeffm@suse.de
Subject: Re: [patch 00/04] RFC: Staging tree (drivers/staging)
Message-Id: <20081009141720.5e893af6.akpm@linux-foundation.org>
In-Reply-To: <20081009210137.GA7126@cs181140183.pp.htv.fi>
References: <20080924230054.GA27730@suse.de>
	<20081009210137.GA7126@cs181140183.pp.htv.fi>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Oct 2008 00:01:37 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> On Wed, Sep 24, 2008 at 04:00:54PM -0700, Greg KH wrote:
> > As we all discussed at the Kernel Summit this past week, I said I would
> > create a drivers/staging directory and start throwing lots of drivers
> > that are not of "mergable" status into it.
> >...
> > The 3rd patch creates the drivers/staging/ directory and Kconfig entries
> > and adds it to the build system.
> > 
> > The 4th patch is an example of a driver that would go into this
> > directory, along with a driver_name.README file detailing what needs to
> > be done to this driver for cleanup/fixing, and who to contact about it.
> > It's also in such bad shape it doesn't even build against the kernel
> > kernel :)
> > 
> > (I'll fix that up before submitting, all drivers should at least build
> > properly...)
> > 
> > So, does this all look good to everyone?  Any questions/issues?
> > 
> > Oh, I guess I should add a MAINTAINER entry for this section of the
> > kernel, so to paraphrase Linus, I now get to be known as the "Maintainer
> > of Crap".
> 
> Sorry for being late in the discussion, I'm currently catching up with 
> my email backlog.
> 
> What does that mean in practice for kernel development?
> 
> Will breaking crap be considered OK?
> 
> As an example, let's assume some crap drivers use the BKL in a way that 
> it might require the BKL in some core part of the kernel. Will the 
> person removing the BKL in the core part of the kernel be forced to fix 
> the locking of all possibly affected crap drivers no matter how broken 
> and undocumented it is, or can he simply ignore the crap and leave the 
> fixing to the Maintainer of Crap?
> 

<collapses in a hysterical seizure>

Every development tree right now will go out and breezily break random
other development trees with nary a care in the world.

What difference does one more tree make?
