Return-Path: <linux-kernel-owner+w=401wt.eu-S1757143AbYC1PD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143AbYC1PD0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 11:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756544AbYC1PDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 11:03:16 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:41478 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756851AbYC1PDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 11:03:14 -0400
Date: Fri, 28 Mar 2008 16:03:12 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Ingo Molnar <mingo@elte.hu>
cc: David Brownell <david-b@pacbell.net>, Mark Lord <lkml@rtr.ca>,
       David Miller <davem@davemloft.net>, jkosina@suse.cz, gregkh@suse.de,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, pavel@suse.cz,
       akpm@linux-foundation.org, rtc-linux@googlegroups.com
Subject: Re: 2.6.25-rc7: Ugh.
In-Reply-To: <20080328102010.GA633@elte.hu>
Message-ID: <alpine.LNX.1.10.0803281557160.27567@fbirervta.pbzchgretzou.qr>
References: <20080327160700.GB828@suse.de> <200803272358.20081.david-b@pacbell.net> <20080328091645.GI21413@elte.hu> <200803280249.42193.david-b@pacbell.net> <20080328102010.GA633@elte.hu>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2008-03-28 11:20, Ingo Molnar wrote:
>
> it's not just about being gentle: it's that there are thousands of
> .config options that are confusing to most users, so our defaults and
> rules must make sense. If we think that an approach is superior (which
> your new RTC code certainly is), we have to take up the responsibility
> of pushing that as a prominent, default choice and excluding the old
> code. That ends up benefiting everyone, reduces complexity of the
> kernel. You wont see anyone shed tears for the old code.

Users with audio-related usage patterns do, as SND_RTCTIMER
still depends on old rtc :-/
