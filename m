Return-Path: <linux-kernel-owner+w=401wt.eu-S933230AbXC0XFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933230AbXC0XFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 19:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933258AbXC0XFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 19:05:55 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:34929 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933230AbXC0XFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 19:05:54 -0400
To: pavel@ucw.cz
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-reply-to: <20070327223324.GB6752@elf.ucw.cz> (message from Pavel Machek on
	Wed, 28 Mar 2007 00:33:24 +0200)
Subject: Re: [patch] add file position info to proc
References: <E1HVELJ-0006ed-00@dorka.pomaz.szeredi.hu> <20070327212419.GA5817@ucw.cz> <20070327143629.9c8953db.akpm@linux-foundation.org> <E1HWJRv-00052q-00@dorka.pomaz.szeredi.hu> <20070327223324.GB6752@elf.ucw.cz>
Message-Id: <E1HWKjO-0005FW-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 28 Mar 2007 01:05:34 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > > For each fd the information is provided in the following format:
> > > > > 
> > > > > pos:	1234
> > > > > flags:	0100002
> > > > 
> > > > Octal? Maybe we should use more traditional hex here?
> > 
> > It's octal in <fcntl.h>, so it's easier for a human to read.
> > 
> > > Good point.  The O_foo flags are per-arch, so this field has the potential
> > > to be subtly different on different architectures, which is unpleasing.
> > > 
> > > > Or even list flags by name?
> > > 
> > > urg.  Simple enough to do (lookup table, please).  But is it worth it? 
> > > Perhaps just remove that field?
> > 
> > I wouldn't mind.  But leaving it to an application or for a human to
> > sort out is OK I guess.  There are lots of non-portable numbers in
> > proc.
> 
> Hmm, I do not think we want non-portable numbers in proc. What are
> other examples?

Signal masks in PID/status for example.  I'm sure there are others.

Miklos
