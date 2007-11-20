Return-Path: <linux-kernel-owner+w=401wt.eu-S1764795AbXKTVsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764795AbXKTVsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 16:48:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764717AbXKTVsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 16:48:41 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34041
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1764709AbXKTVsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 16:48:40 -0500
Date: Tue, 20 Nov 2007 13:48:39 -0800 (PST)
Message-Id: <20071120.134839.229691661.davem@davemloft.net>
To: drepper@redhat.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, torvalds@linux-foundation.org
Subject: Re: [PATCHv4 5/6] Allow setting O_NONBLOCK flag for new sockets
From: David Miller <davem@davemloft.net>
In-Reply-To: <474305A5.7070100@redhat.com>
References: <200711200653.lAK6rE6B025891@devserv.devel.redhat.com>
	<20071119.235944.82120402.davem@davemloft.net>
	<474305A5.7070100@redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulrich Drepper <drepper@redhat.com>
Date: Tue, 20 Nov 2007 08:04:53 -0800

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> David Miller wrote:
> > Where does this INDIRECT_PARAM() macro get defined?  I do not
> > see it being defined anywhere in these patches.
> 
> Defined in <linux/indirect.h>:
> 
> +#define INDIRECT_PARAM(set, name) current->indirect_params.set.name
> 
> Not my idea, I was following one review comment.

This was not in the patches you posted, I double checked before
sending my reply.
