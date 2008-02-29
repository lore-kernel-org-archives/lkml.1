Return-Path: <linux-kernel-owner+w=401wt.eu-S1761057AbYB2Uu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761057AbYB2Uu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 15:50:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751086AbYB2Uut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 15:50:49 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:49401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750775AbYB2Uus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 15:50:48 -0500
Date: Fri, 29 Feb 2008 12:49:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bill Nottingham <notting@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC, BAD IDEA] /proc/tty/console
Message-Id: <20080229124942.fd402273.akpm@linux-foundation.org>
In-Reply-To: <20080229150730.GA8209@nostromo.devel.redhat.com>
References: <20080227181857.GA3137@nostromo.devel.redhat.com>
	<20080228224923.fbbd97dc.akpm@linux-foundation.org>
	<20080229150730.GA8209@nostromo.devel.redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Feb 2008 10:07:30 -0500
Bill Nottingham <notting@redhat.com> wrote:

> Andrew Morton (akpm@linux-foundation.org) said: 
> > > The attached patch adds /proc/tty/console. The contents of it are
> > > simply a description of the current drivers attached to /dev/console.
> > > For example, a boot with 'console=ttyS3,115200n1 console=tty0' would
> > > yield:
> > > 
> > > # cat /proc/tty/console
> > > unknown             /dev/tty0
> > > serial              /dev/ttyS3
> > 
> > I must say that the what-consoles-are-registered problem makes my head spin
> > sometimes too.  Seems a worthy objective.
> > 
> > However I think that a bunch of plain old printks which are emitted when a
> > console is added or removed would suffice?
> 
> We already do that in register_console(), albeit without flags.

oh.

> My concern is I'd like to easily programmatically do something with this
> info - ideally it would be in sysfs so it can easily be used from udev
> or something similar.

That's the sort of information which really must be in the changelog, fully
spelled out.
