Return-Path: <linux-kernel-owner+w=401wt.eu-S1754180AbYLRWeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbYLRWeB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 17:34:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbYLRWdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 17:33:49 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:46007 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbYLRWds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 17:33:48 -0500
Date: Fri, 19 Dec 2008 00:33:46 +0200 (EET)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: Matt Mackall <mpm@selenic.com>
cc: David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] Stop scaring users with "treason uncloaked!"
In-Reply-To: <1229638581.3726.546.camel@calx>
Message-ID: <Pine.LNX.4.64.0812190028560.12061@wrl-59.cs.helsinki.fi>
References: <1229638581.3726.546.camel@calx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Dec 2008, Matt Mackall wrote:

> These debug messages are uninformative and extremely alarming. Rather
> than reporting a peer as a treacherous attacker, report it more
> correctly as simply broken. 

Last time (well, ignoring some report on ancient vendor kernel) I've seen 
this to trigger it wasn't the fault of the peer but ours (we sent past the 
advertized window and window ended up being shrunk to zero). I agree that 
the message as-is is not very good but your change is not very good 
either.

> -			LIMIT_NETDEBUG(KERN_DEBUG "TCP: Treason uncloaked! Peer " NIPQUAD_FMT ":%u/%u shrinks window %u:%u. Repaired.\n",
> +			LIMIT_NETDEBUG(KERN_DEBUG "TCP: Broken peer " NIPQUAD_FMT ":%u/%u shrinks window %u:%u. Repaired.\n",

This won't apply to net-next on which you should base anything new (and 
net related).

-- 
 i.
