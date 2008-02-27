Return-Path: <linux-kernel-owner+w=401wt.eu-S1758110AbYB0S6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110AbYB0S6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 13:58:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755709AbYB0S61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 13:58:27 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:11217 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518AbYB0S60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 13:58:26 -0500
Date: Wed, 27 Feb 2008 10:56:09 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Bill Nottingham <notting@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC, BAD IDEA] /proc/tty/console
Message-Id: <20080227105609.bf26c592.randy.dunlap@oracle.com>
In-Reply-To: <20080227185225.GB3137@nostromo.devel.redhat.com>
References: <20080227181857.GA3137@nostromo.devel.redhat.com>
	<20080227103730.761c35d4.randy.dunlap@oracle.com>
	<20080227185225.GB3137@nostromo.devel.redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008 13:52:25 -0500 Bill Nottingham wrote:

> Randy Dunlap (randy.dunlap@oracle.com) said: 
> > > I'm not seriously proposing this. But, as far as I can tell, this
> > > information isn't exposed to userspace anywhere, and it's a useful
> > > thing to know. I'm certainly open for better ideas on how to expose
> > > this (sysfs attributes? other?)
> > > 
> > > ....
> > > 
> > > The attached patch adds /proc/tty/console. The contents of it are
> > > simply a description of the current drivers attached to /dev/console.
> > > For example, a boot with 'console=ttyS3,115200n1 console=tty0' would
> > > yield:
> > > 
> > > # cat /proc/tty/console
> > > unknown             /dev/tty0
> > > serial              /dev/ttyS3
> > > 
> > 
> > So it omits other consoles (non-tty) intentionally?
> > or does it include them even though the procfs filename contains "tty"?
> 
> It only does consoles that have a tty_driver, as those are the ones I'd
> find most interesting.
> 
> > Anyway, I'd like to see something like this.
> > Compare http://www.xenotime.net/linux/patches/consoles-list.patch
> > (April-2006).
> 
> Reading that, unless I'm missing something, you'd lose the device name
> distinction (i.e., *which* serial port).

I don't recall about that, but it would be Bad if correct.
I meant to list *all* consoles.  I'm interested in netconsole,
console=lp0, console=ttyUSB0, etc., as well as serial port consoles.

Thanks.
---
~Randy
