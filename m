Return-Path: <linux-kernel-owner+w=401wt.eu-S932626AbYB2PHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626AbYB2PHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 10:07:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759116AbYB2PHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 10:07:37 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60127 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759254AbYB2PHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 10:07:36 -0500
Date: Fri, 29 Feb 2008 10:07:30 -0500
From: Bill Nottingham <notting@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC, BAD IDEA] /proc/tty/console
Message-ID: <20080229150730.GA8209@nostromo.devel.redhat.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20080227181857.GA3137@nostromo.devel.redhat.com> <20080228224923.fbbd97dc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080228224923.fbbd97dc.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton (akpm@linux-foundation.org) said: 
> > The attached patch adds /proc/tty/console. The contents of it are
> > simply a description of the current drivers attached to /dev/console.
> > For example, a boot with 'console=ttyS3,115200n1 console=tty0' would
> > yield:
> > 
> > # cat /proc/tty/console
> > unknown             /dev/tty0
> > serial              /dev/ttyS3
> 
> I must say that the what-consoles-are-registered problem makes my head spin
> sometimes too.  Seems a worthy objective.
> 
> However I think that a bunch of plain old printks which are emitted when a
> console is added or removed would suffice?

We already do that in register_console(), albeit without flags.

My concern is I'd like to easily programmatically do something with this
info - ideally it would be in sysfs so it can easily be used from udev
or something similar.

Bill
