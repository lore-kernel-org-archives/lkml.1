Return-Path: <linux-kernel-owner+w=401wt.eu-S1756208AbXFPQpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbXFPQpm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 12:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754652AbXFPQpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 12:45:34 -0400
Received: from wine.ocn.ne.jp ([220.111.47.146]:53172 "EHLO
	smtp.wine.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555AbXFPQpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 12:45:34 -0400
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading andmanipulation,pathname matching
From: Tetsuo Handa <from-lsm@I-love.SAKURA.ne.jp>
References: <20070609001703.GA17644@kroah.com>
	<466C303E.5010304@novell.com>
	<20070615165054.GA11345@kroah.com>
	<200706170044.DJF02182.TtMPNGNS@I-love.SAKURA.ne.jp>
	<20070616162653.GC20990@kroah.com>
In-Reply-To: <20070616162653.GC20990@kroah.com>
Message-Id: <200706170145.HBG40443.GTtNNPSM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50]
X-Accept-Language: ja,en
Date: Sun, 17 Jun 2007 01:45:31 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Greg KH wrote:
> On Sun, Jun 17, 2007 at 12:44:08AM +0900, Tetsuo Handa wrote:
> > Can the daemon using inotify access to all pathnames in all process's
> > namespaces?
> 
> I don't see why not, do you?
> 
> > Are the namespace the daemon has and the namespace of pathnames
> > notified via inotify always the same?
> 
> If they are in the same namespace, then yes, they will as far as I can
> tell.  Do you think this is incorrect?

At least, I think SELinux's "make relabel" can't relabel
files that are not in the namespace of "make" process.

I don't know how to use inotify, but what I worried is ...

If there are cases they are in different namespace,
it is impossible to relabel using userland daemon
(i.e. deferred-relabeling won't work)
unless all pathnames of all namespaces are somehow
accessible via inotify.

Thanks.
