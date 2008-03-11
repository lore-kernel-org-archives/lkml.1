Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbYCKKqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbYCKKqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 06:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751013AbYCKKqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 06:46:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58423 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbYCKKq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 06:46:29 -0400
Date: Tue, 11 Mar 2008 11:48:22 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-pm@lists.linux-foundation.org,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Dave Jones <davej@codemonkey.org.uk>, Andi Kleen <andi@firstfloor.org>,
       Alan Stern <stern@rowland.harvard.edu>, Adam Belay <abelay@novell.com>,
       Lee Revell <rlrevell@joe-job.com>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [linux-pm] [PATCH] cpuidle: avoid singing capacitors
Message-ID: <20080311104822.GC18917@one.firstfloor.org>
References: <20080303231033.GB15255@one.firstfloor.org> <20080304040048.GA31562@codemonkey.org.uk> <20080304071423.0e6b71c1@mjolnir.drzeus.cx> <20080304181924.70aaf8c1@mjolnir.drzeus.cx> <924EFEDD5F540B4284297C4DC59F3DEEA77031@orsmsx423.amr.corp.intel.com> <20080305070201.0d16cd40@mjolnir.drzeus.cx> <20080305094023.6486ebdf@mjolnir.drzeus.cx> <20080306092730.4412d085@mjolnir.drzeus.cx> <20080309151659.63d54f38@mjolnir.drzeus.cx> <20080311085145.5fcf3186@mjolnir.drzeus.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080311085145.5fcf3186@mjolnir.drzeus.cx>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have now found a very hacky workaround that is slightly better than
> disabling C3 altogether; making C3 exclusive to one core at a time. It
> seems to kill the noise and the system now spends 50% in C3, instead of
> 0%.

I suspect it won't do much of C3 if only one core is idle this way.
Most likely you just disabled C3 this way in a way invisible to software.

-Andi

