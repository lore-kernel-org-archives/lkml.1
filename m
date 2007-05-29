Return-Path: <linux-kernel-owner+w=401wt.eu-S1759961AbXE2GKC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759961AbXE2GKC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 02:10:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698AbXE2GJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 02:09:54 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:41292 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872AbXE2GJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 02:09:53 -0400
Date: Tue, 29 May 2007 08:09:33 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "Robert P. J. Day" <rpjday@mindspring.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: stuff ready to be deleted?
In-Reply-To: <Pine.LNX.4.64.0705281818370.17410@localhost.localdomain>
Message-ID: <Pine.LNX.4.61.0705290807530.11140@yvahk01.tjqt.qr>
References: <Pine.LNX.4.64.0705281612560.15449@localhost.localdomain>
 <Pine.LNX.4.61.0705282326480.11140@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0705281818370.17410@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 28 2007 18:25, Robert P. J. Day wrote:
>On Mon, 28 May 2007, Jan Engelhardt wrote:

>> >currently, the list contains the items:
>> >
>> >    * 4 Traffic policing
>>
>> CONFIG_NET_SCHED? CONFIG_NET_ACT_POLICE? Neither seems
>> marked as deprecated/obsoleted in Kconfig.
>
>the "traffic policing" entry in that list refers specifically to the
>config option "CLS_NET_POLICE" in net/sched/Kconfig:
>
>config NET_CLS_POLICE
>        bool "Traffic Policing (obsolete)"
>        depends on NET_CLS_ACT!=y
>
>so ... does "obsolete" really mean "obsolete"?

Have you taken a look at the Makefile? See this oddity:

obj-$(CONFIG_NET_ACT_POLICE)    += act_police.o
obj-$(CONFIG_NET_CLS_POLICE)    += act_police.o

So is the Kconfig entry all that is obsolete?



	Jan
-- 
