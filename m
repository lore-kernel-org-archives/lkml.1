Return-Path: <linux-kernel-owner+w=401wt.eu-S1763358AbXE1Wm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763358AbXE1Wm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 18:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbXE1WmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 18:42:19 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:53249 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbXE1WmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 18:42:18 -0400
X-Originating-Ip: 72.143.65.211
Date: Mon, 28 May 2007 18:41:01 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: stuff ready to be deleted?
In-Reply-To: <Pine.LNX.4.64.0705281818370.17410@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0705281840110.17870@localhost.localdomain>
References: <Pine.LNX.4.64.0705281612560.15449@localhost.localdomain>
 <Pine.LNX.4.61.0705282326480.11140@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0705281818370.17410@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 May 2007, Robert P. J. Day wrote:

> On Mon, 28 May 2007, Jan Engelhardt wrote:
>
> >
> > On May 28 2007 16:15, Robert P. J. Day wrote:
> > >removing dead content from the tree:
> > >
> > >http://fsdev.net/wiki/index.php?title=Kernel_Janitor%27s_Todo_List
> > >
> > >currently, the list contains the items:
> > >
> > >    * 4 Traffic policing
> >
> > CONFIG_NET_SCHED? CONFIG_NET_ACT_POLICE? Neither seems
> > marked as deprecated/obsoleted in Kconfig.
>
> the "traffic policing" entry in that list refers specifically to the
> config option "CLS_NET_POLICE" in net/sched/Kconfig:
>
> config NET_CLS_POLICE
>         bool "Traffic Policing (obsolete)"
>         depends on NET_CLS_ACT!=y
>         select NET_ESTIMATOR
>         ---help---
>           Say Y here if you want to do traffic policing, i.e. strict
>           bandwidth limiting. This option is obsoleted by the traffic
>           policer implemented as action, it stays here for compatibility
>           reasons.
>
> so ... does "obsolete" really mean "obsolete"?

whoops, the URL i gave above is only for the main page, not for the
specific "stuff to be removed" list here:

http://fsdev.net/wiki/index.php?title=Stuff_to_be_removed

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
