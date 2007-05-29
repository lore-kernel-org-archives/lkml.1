Return-Path: <linux-kernel-owner+w=401wt.eu-S1763970AbXE2IVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763970AbXE2IVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 04:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbXE2IVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 04:21:46 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:44632 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbXE2IVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 04:21:45 -0400
X-Originating-Ip: 72.143.65.211
Date: Tue, 29 May 2007 04:20:24 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: stuff ready to be deleted?
In-Reply-To: <Pine.LNX.4.61.0705290807530.11140@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.64.0705290419370.23055@localhost.localdomain>
References: <Pine.LNX.4.64.0705281612560.15449@localhost.localdomain>
 <Pine.LNX.4.61.0705282326480.11140@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0705281818370.17410@localhost.localdomain>
 <Pine.LNX.4.61.0705290807530.11140@yvahk01.tjqt.qr>
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

On Tue, 29 May 2007, Jan Engelhardt wrote:

>
> On May 28 2007 18:25, Robert P. J. Day wrote:
> >On Mon, 28 May 2007, Jan Engelhardt wrote:
>
> >> >currently, the list contains the items:
> >> >
> >> >    * 4 Traffic policing
> >>
> >> CONFIG_NET_SCHED? CONFIG_NET_ACT_POLICE? Neither seems
> >> marked as deprecated/obsoleted in Kconfig.
> >
> >the "traffic policing" entry in that list refers specifically to the
> >config option "CLS_NET_POLICE" in net/sched/Kconfig:
> >
> >config NET_CLS_POLICE
> >        bool "Traffic Policing (obsolete)"
> >        depends on NET_CLS_ACT!=y
> >
> >so ... does "obsolete" really mean "obsolete"?
>
> Have you taken a look at the Makefile? See this oddity:
>
> obj-$(CONFIG_NET_ACT_POLICE)    += act_police.o
> obj-$(CONFIG_NET_CLS_POLICE)    += act_police.o
>
> So is the Kconfig entry all that is obsolete?

ah, i hadn't noticed that.  how odd.  now i don't know *what* to
think.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
