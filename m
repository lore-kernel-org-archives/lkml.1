Return-Path: <linux-kernel-owner+w=401wt.eu-S932418AbXC0Voi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418AbXC0Voi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 17:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932810AbXC0Voi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 17:44:38 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:36131 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932778AbXC0Voh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 17:44:37 -0400
To: akpm@linux-foundation.org
CC: pavel@ucw.cz, miklos@szeredi.hu, linux-kernel@vger.kernel.org
In-reply-to: <20070327143629.9c8953db.akpm@linux-foundation.org> (message from
	Andrew Morton on Tue, 27 Mar 2007 14:36:29 -0700)
Subject: Re: [patch] add file position info to proc
References: <E1HVELJ-0006ed-00@dorka.pomaz.szeredi.hu>
	<20070327212419.GA5817@ucw.cz> <20070327143629.9c8953db.akpm@linux-foundation.org>
Message-Id: <E1HWJRv-00052q-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 27 Mar 2007 23:43:27 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Hi!
> > 
> > > From: Miklos Szeredi <mszeredi@suse.cz>
> > > 
> > > This patch adds support for finding out the current file position,
> > > open flags and possibly other info in the future.
> > > 
> > > These new entries are added:
> > > 
> > >   /proc/PID/fdinfo/FD
> > >   /proc/PID/task/TID/fdinfo/FD
> > > 
> > > For each fd the information is provided in the following format:
> > > 
> > > pos:	1234
> > > flags:	0100002
> > 
> > Octal? Maybe we should use more traditional hex here?

It's octal in <fcntl.h>, so it's easier for a human to read.

> Good point.  The O_foo flags are per-arch, so this field has the potential
> to be subtly different on different architectures, which is unpleasing.
> 
> > Or even list flags by name?
> 
> urg.  Simple enough to do (lookup table, please).  But is it worth it? 
> Perhaps just remove that field?

I wouldn't mind.  But leaving it to an application or for a human to
sort out is OK I guess.  There are lots of non-portable numbers in
proc.

Miklos
