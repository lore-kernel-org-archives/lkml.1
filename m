Return-Path: <linux-kernel-owner+w=401wt.eu-S1757324AbYBMAgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324AbYBMAgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 19:36:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763520AbYBMAfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 19:35:53 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55011
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1763655AbYBMAfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 19:35:52 -0500
Date: Tue, 12 Feb 2008 16:36:23 -0800 (PST)
Message-Id: <20080212.163623.132476636.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: James.Bottomley@HansenPartnership.com, jeff@garzik.org,
       arjan@infradead.org, greg@kroah.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.00.0802121051341.2920@woody.linux-foundation.org>
References: <1202840682.3137.83.camel@localhost.localdomain>
	<alpine.LFD.1.00.0802121037340.2920@woody.linux-foundation.org>
	<alpine.LFD.1.00.0802121051341.2920@woody.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 12 Feb 2008 10:59:00 -0800 (PST)

> That sure as hell would put the pain on API changes solidly where it
> belongs.

If a person does a driver API change and does all the work to sweep
the entire tree updating all the drivers, doesn't it penalize that
person a bit much to stick a new driver in front of that work?

People write code on top of infrastructure, both new and old, not the
other way around.  At least to me, that seems how the merging ought to
work too.
