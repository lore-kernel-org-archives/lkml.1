Return-Path: <linux-kernel-owner+w=401wt.eu-S1754088Ab0AMFmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab0AMFmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 00:42:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753756Ab0AMFmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 00:42:51 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48271
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752826Ab0AMFmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 00:42:50 -0500
Date: Tue, 12 Jan 2010 21:42:59 -0800 (PST)
Message-Id: <20100112.214259.169429418.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2010-01-12
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100112163924.GA2987@tuxdriver.com>
References: <20100112163924.GA2987@tuxdriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 12 Jan 2010 11:39:24 -0500

> I apologize that it has been a while (i.e. too long) since my last pull
> request.  I was giving this round extra time to bake...
> 
> Most of these are the usual one-liners and/or isolated fixes.  One
> exception is "mac80211: fix skb buffering issue" from Johannes.  The
> changelog describes the issue, but basically when the master netdev got
> removed our multiqueue support went along with it.  This led to some
> regressions that manifested as queueing/congestion problems.  The fix
> from Johannes adds multiqueue support to the current mac80211
> implementation.  Because this was a significant (but IMHO necessary)
> change, I allowed this to bake over the last week or so and collected a
> few fixes on top of that change in the process.
> 
> One other change of note is an EEPROM checksum change for Atheros
> devices.  It seems there were some devices that handled their checksum
> differently and they were being disabled after "ath5k: enable EEPROM
> checksum check".  This has also been baking for a while and no problems
> have been reported.

Pulled, thanks John.

> Finally, thanks for the git advice after the last pull request!  One
> more incremental step in improving my workflow... :-)

Any time :)
