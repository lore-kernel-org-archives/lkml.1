Return-Path: <linux-kernel-owner+w=401wt.eu-S1761523AbYBLUY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761523AbYBLUY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 15:24:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753269AbYBLUYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 15:24:19 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46144 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753242AbYBLUYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 15:24:18 -0500
Date: Tue, 12 Feb 2008 12:23:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: torvalds@linux-foundation.org, jeff@garzik.org, davem@davemloft.net,
       arjan@infradead.org, greg@kroah.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-Id: <20080212122301.376dbda8.akpm@linux-foundation.org>
In-Reply-To: <20080212200354.GB16885@flint.arm.linux.org.uk>
References: <20080211203146.3d28d1a0@laptopd505.fenrus.org>
	<20080212044314.GA4888@kroah.com>
	<20080211211751.3e265754@laptopd505.fenrus.org>
	<20080211.221126.230471463.davem@davemloft.net>
	<47B1CB08.4020101@garzik.org>
	<alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org>
	<20080212200354.GB16885@flint.arm.linux.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008 20:03:54 +0000
Russell King <rmk+lkml@arm.linux.org.uk> wrote:

> (3) is effectively what akpm does with his tree - when a patch conflicts
> with other changes, he throws the changes out and bangs peoples heads
> together to get a new set of patches generated which work together.

Actually I'll usually (much >90%) just queue another patch which fixes the
fallout and will drop that once the upstreams sort things out.

I'll only drop a subsystem tree in extremis.  One reason for this is
that I'll have a pile of other patches which are dependent upon that
subsystem tree and which would need reworking.  And un-reworking once the
subsytem tree is undropped.

And the trees which are most likely to cause conflicts tend to also be
the trees upon which other patches are dependent.  Mainly because those
trees are larger and more spread out.
