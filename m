Return-Path: <linux-kernel-owner+w=401wt.eu-S1756188AbXGIJlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188AbXGIJlh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 05:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752494AbXGIJla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 05:41:30 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:41227 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbXGIJl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 05:41:29 -0400
To: oliver@neukum.org
CC: miklos@szeredi.hu, rjw@sisk.pl, pavel@ucw.cz, paulus@samba.org,
       stern@rowland.harvard.edu, johannes@sipsolutions.net,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, benh@kernel.crashing.org, nigel@nigel.suspend2.net
In-reply-to: <200707091136.33581.oliver@neukum.org> (message from Oliver
	Neukum on Mon, 9 Jul 2007 11:36:32 +0200)
Subject: Re: malicious filesystems (was Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway)
References: <200707050858.03638.oliver@neukum.org> <200707082307.15616.rjw@sisk.pl> <E1I7pXr-0001Qn-00@dorka.pomaz.szeredi.hu> <200707091136.33581.oliver@neukum.org>
Message-Id: <E1I7pj9-0001TE-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 09 Jul 2007 11:40:19 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > In that case the "we need suspend to be invisible to userspace" as a
> > reason to use the freezer would also be moot, since if you don't
> > schedule userspace after offlining the CPUs, it can't notice this.
> 
> After? Can you do the offlining atomically?

Don't know.  Wait for all CPUs to reach a scheduling point and then
take them offline?  Doesn't sound too difficult.

Miklos
