Return-Path: <linux-kernel-owner+w=401wt.eu-S1758940AbXGCGvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940AbXGCGvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 02:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbXGCGvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 02:51:32 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:36191 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbXGCGvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 02:51:32 -0400
To: oliver@neukum.org
CC: mjg59@srcf.ucam.org, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
In-reply-to: <200707030813.53481.oliver@neukum.org> (message from Oliver
	Neukum on Tue, 3 Jul 2007 08:13:53 +0200)
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
References: <20070703042916.GA17240@srcf.ucam.org> <200707030813.53481.oliver@neukum.org>
Message-Id: <E1I5cE7-0003E4-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 03 Jul 2007 08:51:07 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Suspend to RAM on a machine with / on a fuse filesystem turns out to be 
> > a screaming nightmare - either the suspend fails because syslog (for 
> > instance) can't be frozen, or the machine deadlocks for some other 
> > reason I haven't tracked down. We could "fix" fuse, or alternatively we 
> > could do what we do for suspend to RAM on other platforms (PPC and APM) 
> > and just not use the freezer.
> 
> Only if you want to audit all character devices' read() and write()
> methods for races against suspend().
> / on fuse is a bad idea.

What makes / special?  Why aren't all fuse filesystems affected?
Suspend isn't trying to do I/O on the root fs, is it?

Miklos
