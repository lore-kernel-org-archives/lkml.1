Return-Path: <linux-kernel-owner+w=401wt.eu-S933730AbXCFBJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933730AbXCFBJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 20:09:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933728AbXCFBJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 20:09:13 -0500
Received: from smtp.osdl.org ([65.172.181.24]:44196 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933707AbXCFBJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 20:09:11 -0500
Date: Mon, 5 Mar 2007 17:08:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Greg KH <greg@kroah.com>, Bron Gondwana <brong@fastmail.fm>,
       Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, yi.zhu@intel.com, jketreno@linux.intel.com
Subject: Re: Recent wireless breakage (ipw2200, iwconfig, NetworkManager)
Message-Id: <20070305170849.c042e802.akpm@linux-foundation.org>
In-Reply-To: <20070306005625.GC19634@thunk.org>
References: <20070304220857.GH23311@waste.org>
	<20070305011625.GA7681@kroah.com>
	<20070305064229.GJ23311@waste.org>
	<20070305070248.GA30699@kroah.com>
	<20070305071325.GK23311@waste.org>
	<20070305154609.GA3626@irc.pl>
	<20070305211425.GR16722@waste.org>
	<20070306002457.GA7078@brong.net>
	<20070306003715.GA12566@kroah.com>
	<20070306005625.GC19634@thunk.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Mar 2007 19:56:25 -0500
Theodore Tso <tytso@mit.edu> wrote:

> So the question really is are we really done making changes to sysfs,
> or maybe what we should do is talk about major version numbers to
> sysfs.

Perhaps using a config option wasn't the right way to do this - a kernel
boot parameter might be better.

In fact, one could envisage a kernel boot parameter "sysfs_version=N" which 
will allow distro people to select the sysfs-of-the-day which works with their
userspace.

Because it does appear that we need _something_ which will get us away from this
ongoing problem of needing to keep the kernel and userspace synchronised across
sysfs changes.
