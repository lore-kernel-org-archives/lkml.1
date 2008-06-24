Return-Path: <linux-kernel-owner+w=401wt.eu-S1756487AbYFXBf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487AbYFXBf6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 21:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbYFXBfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 21:35:50 -0400
Received: from mail.queued.net ([207.210.101.209]:3597 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822AbYFXBft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 21:35:49 -0400
Date: Mon, 23 Jun 2008 21:38:30 -0400
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: drzeus-sdhci@drzeus.cx, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [OLPC] sdhci: add quirk for the Marvell CaFe's
 interrupt timeout
Message-ID: <20080623213830.07ed73d8@xo-debian>
In-Reply-To: <20080623170850.6b289569.akpm@linux-foundation.org>
References: <20080623101352.3bbaf5b0@xo-debian>
	<20080623170449.6567d857.akpm@linux-foundation.org>
	<20080623170850.6b289569.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2008 17:08:50 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 23 Jun 2008 17:04:49 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > And it will cause conflicts with overlapping changes in linux-next.
> 
> 
> oops, I lied.  The problem was that it secretly depended upon
> olpc-sdhci-add-quirk-for-the-marvell-cafes-vdd-powerup-issue.patch
> 
> So if we want to fix thsi issue in 2.6.26 we need to merge both
> 
> olpc-sdhci-add-quirk-for-the-marvell-cafes-vdd-powerup-issue.patch
> 
> and
> 
> olpc-sdhci-add-quirk-for-the-marvell-cafes-interrupt-timeout.patch
> 
> yes?


Correct.  I originally wasn't going to send the interrupt-timeout
patch (but was shown that the bug still existed), which is why the two
patches weren't sent as a series.  Sorry!
