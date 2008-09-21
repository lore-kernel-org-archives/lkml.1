Return-Path: <linux-kernel-owner+w=401wt.eu-S1753567AbYIUWlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbYIUWlQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 18:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbYIUWlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 18:41:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58234 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752495AbYIUWlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 18:41:06 -0400
Date: Sun, 21 Sep 2008 23:38:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, ipw2100-devel@lists.sourceforge.net,
       linux-wireless@vger.kernel.org, yi.zhu@intel.com,
       reinette.chatre@intel.com, jgarzik@pobox.com, linville@tuxdriver.com,
       davem@davemloft.net
Subject: Re: Mark IPW2100 as BROKEN: Fatal interrupt. Scheduling firmware
 restart.
Message-ID: <20080921233819.32714483@lxorguk.ukuu.org.uk>
In-Reply-To: <20080921205706.GA24545@2ka.mipt.ru>
References: <20080921172316.GA6306@2ka.mipt.ru>
	<20080921110422.1d010b96@infradead.org>
	<20080921182835.GA11473@2ka.mipt.ru>
	<20080921113513.16677c4e@infradead.org>
	<20080921190050.GA20484@2ka.mipt.ru>
	<1222024444.3023.53.camel@johannes.berg>
	<20080921193809.GA8735@2ka.mipt.ru>
	<20080921124332.67ddc13a@infradead.org>
	<20080921202057.GB25052@2ka.mipt.ru>
	<20080921132753.5689b564@infradead.org>
	<20080921205706.GA24545@2ka.mipt.ru>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > still more complex than needed; a WARN_ON_ONCE() will be enough.
> 
> That allows to dump whatever number of warnings you want. The more we
> have, the louder will be customers scream.

But if Intel don't care then you can scream all you like 8)

A WARN_ON_ONCE is sufficient to capture an idea of how many people it is
effecting and maybe to figure out what the trigger is from their reports,
at that point there is some chance to get it fixed (especially if its
remotely triggerable ;))

Alan
