Return-Path: <linux-kernel-owner+w=401wt.eu-S932300AbXGaQkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300AbXGaQkB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 12:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760177AbXGaQjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 12:39:53 -0400
Received: from compulypse.net ([212.227.20.180]:21562 "EHLO compulypse.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759201AbXGaQjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 12:39:52 -0400
Subject: Re: [ck] Linux Kernel cfs scheduler and xorg kbd
From: "<::.. Teresa_II ..::>" <teresa@kvitka.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: CK Mailinglist <ck@vds.kolivas.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070731142713.GD22209@elte.hu>
References: <1185827130.26459.16.camel@xtower.fri>
	 <1185882179.26459.36.camel@xtower.fri>  <20070731142713.GD22209@elte.hu>
Content-Type: text/plain; charset=utf-8
Date: Tue, 31 Jul 2007 18:39:23 +0200
Message-Id: <1185899963.26459.53.camel@xtower.fri>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

У вт, 2007-07-31 у 16:27 +0200, Ingo Molnar пише:
> > In gnome-terminal window i just type fast "d" and until i count 1,2 i 
> > hold SHIFT, than i release SHIFT, count 1,2 and than press SHIFT 
> > again. I cound 1,2,1,2,1,2 as i type "d" button. That's the string i 
> > get:
> 
> hm, do you have CONFIG_NO_HZ=y? If yes, could you disable it? Plus can 
> you see the same problem on v2.6.23-rc1 as well (if that kernel boots 
> fine for you).

# zcat /proc/config.gz |grep "_HZ"
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000

Hmm, i will try 2.6.23-rc1 soon.

-- 
Teresa Kalitowska
jid: teresa@kvitka.net

