Return-Path: <linux-kernel-owner+w=401wt.eu-S1753392AbYLSDyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbYLSDyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 22:54:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbYLSDyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 22:54:31 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60936
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751412AbYLSDyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 22:54:31 -0500
Date: Thu, 18 Dec 2008 19:54:33 -0800 (PST)
Message-Id: <20081218.195433.203436159.davem@davemloft.net>
To: mpm@selenic.com
Cc: ilpo.jarvinen@helsinki.fi, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] Stop scaring users with "treason uncloaked!"
From: David Miller <davem@davemloft.net>
In-Reply-To: <1229658561.3726.602.camel@calx>
References: <1229644234.3726.577.camel@calx>
	<20081218.161513.241236470.davem@davemloft.net>
	<1229658561.3726.602.camel@calx>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Mackall <mpm@selenic.com>
Date: Thu, 18 Dec 2008 21:49:21 -0600

> On Thu, 2008-12-18 at 16:15 -0800, David Miller wrote:
> > From: Matt Mackall <mpm@selenic.com>
> > Date: Thu, 18 Dec 2008 17:50:34 -0600
> > 
> > > If you want, we can instead say "Peer %d unexpectedly shrunk window...".
> > > So long as the scary bit is gone, I don't care.
> > 
> > Since we have established that the blame is equally possible to
> > be the local as the remote system, something like:
> > 
> > 	TCP: Unexpected shrink of advertised window detected ...
> > 
> > is probably the best.
> 
> How's this:
> 
> The original message was unhelpful and extremely alarming to our poor
> users, despite its charm. Make it less frightening.
> 
> Signed-off-by: Matt Mackall <mpm@selenic.com>

Looks good, applied, thanks Matt.
