Return-Path: <linux-kernel-owner+w=401wt.eu-S1753142AbYLRXvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbYLRXvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 18:51:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751021AbYLRXu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 18:50:57 -0500
Received: from waste.org ([66.93.16.53]:41015 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbYLRXu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 18:50:56 -0500
Subject: Re: [PATCH] Stop scaring users with "treason uncloaked!"
From: Matt Mackall <mpm@selenic.com>
To: Ilpo =?ISO-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0812190028560.12061@wrl-59.cs.helsinki.fi>
References: <1229638581.3726.546.camel@calx>
	 <Pine.LNX.4.64.0812190028560.12061@wrl-59.cs.helsinki.fi>
Content-Type: text/plain; charset=utf-8
Date: Thu, 18 Dec 2008 17:50:34 -0600
Message-Id: <1229644234.3726.577.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-19 at 00:33 +0200, Ilpo Järvinen wrote:
> On Thu, 18 Dec 2008, Matt Mackall wrote:
> 
> > These debug messages are uninformative and extremely alarming. Rather
> > than reporting a peer as a treacherous attacker, report it more
> > correctly as simply broken. 
> 
> Last time (well, ignoring some report on ancient vendor kernel) I've seen 
> this to trigger it wasn't the fault of the peer but ours (we sent past the 
> advertized window and window ended up being shrunk to zero). I agree that 
> the message as-is is not very good but your change is not very good 
> either.

Here this is the bulk of messages on my server (which is otherwise
fairly quiet).

It really doesn't matter whether the message is technically accurate -
it's mostly there for the benefit of kernel hackers. The average end
user is not going to have the slightest clue what is going on nor should
they even care. An advanced network admin might be able to figure things
out by poking at packet traces, but again: not much reason to care. For
most admins, the vast majority of these treasonous peers won't be under
their administrative control. 

If you want, we can instead say "Peer %d unexpectedly shrunk window...".
So long as the scary bit is gone, I don't care.

-- 
Mathematics is the supreme nostalgia of our time.

