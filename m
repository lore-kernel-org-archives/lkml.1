Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1754051AbYLQMs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbYLQMs5 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 07:48:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbYLQMsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 07:48:46 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:36902 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559AbYLQMsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 07:48:45 -0500
Date: Wed, 17 Dec 2008 13:49:04 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bill Davidsen <davidsen@tmr.com>
Subject: Re: 2.6.28-rc8 big regression in VM
Message-ID: <20081217124904.GG4480@ics.muni.cz>
References: <20081212183810.GA4390@ics.muni.cz> <20081213012115.GA6250@localhost> <20081213095815.GA7143@ics.muni.cz> <20081215011645.GA9707@localhost> <20081215094409.GA4422@ics.muni.cz> <20081216045938.GA1000@localhost> <20081216195219.GA4480@ics.muni.cz> <20081217122726.GA21356@localhost> <20081217123307.GF4480@ics.muni.cz> <20081217124421.GA22317@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081217124421.GA22317@localhost>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 147.251.3.109
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Wed, 17 Dec 2008 13:48:40 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 08:44:21PM +0800, Wu Fengguang wrote:
> So the cache memory shrinks a lot.
> 
> Maybe your 'free' command is reporting wrong numbers?
> Or it's not a quite reproducible problem?

it depends, I think that 100MB of caches which is not dropped is not quite OK.

While using the system without reboots for a long time, 'undroppable' amount
of caches rises until the system is unusable.

-- 
Luká¹ Hejtmánek
