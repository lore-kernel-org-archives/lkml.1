Return-Path: <linux-kernel-owner+w=401wt.eu-S1758723AbXE2IqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723AbXE2IqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 04:46:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbXE2IqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 04:46:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60313
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750707AbXE2Ip7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 04:45:59 -0400
Date: Tue, 29 May 2007 01:46:10 -0700 (PDT)
Message-Id: <20070529.014610.23017882.davem@davemloft.net>
To: rpjday@mindspring.com
Cc: jengelh@linux01.gwdg.de, linux-kernel@vger.kernel.org
Subject: Re: stuff ready to be deleted?
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0705290419370.23055@localhost.localdomain>
References: <Pine.LNX.4.64.0705281818370.17410@localhost.localdomain>
	<Pine.LNX.4.61.0705290807530.11140@yvahk01.tjqt.qr>
	<Pine.LNX.4.64.0705290419370.23055@localhost.localdomain>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Robert P. J. Day" <rpjday@mindspring.com>
Date: Tue, 29 May 2007 04:20:24 -0400 (EDT)

> On Tue, 29 May 2007, Jan Engelhardt wrote:
> 
> >
> > On May 28 2007 18:25, Robert P. J. Day wrote:
> > >On Mon, 28 May 2007, Jan Engelhardt wrote:
> >
> > >> >currently, the list contains the items:
> > >> >
> > >> >    * 4 Traffic policing
> > >>
> > >> CONFIG_NET_SCHED? CONFIG_NET_ACT_POLICE? Neither seems
> > >> marked as deprecated/obsoleted in Kconfig.
> > >
> > >the "traffic policing" entry in that list refers specifically to the
> > >config option "CLS_NET_POLICE" in net/sched/Kconfig:
> > >
> > >config NET_CLS_POLICE
> > >        bool "Traffic Policing (obsolete)"
> > >        depends on NET_CLS_ACT!=y
> > >
> > >so ... does "obsolete" really mean "obsolete"?
> >
> > Have you taken a look at the Makefile? See this oddity:
> >
> > obj-$(CONFIG_NET_ACT_POLICE)    += act_police.o
> > obj-$(CONFIG_NET_CLS_POLICE)    += act_police.o
> >
> > So is the Kconfig entry all that is obsolete?
> 
> ah, i hadn't noticed that.  how odd.  now i don't know *what* to
> think.

Look at what tests that config option in the code, not just
what the makefiles do.
