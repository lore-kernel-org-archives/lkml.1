Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbXFYXWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbXFYXWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 19:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbXFYXWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 19:22:35 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42395 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751960AbXFYXWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 19:22:35 -0400
Date: Mon, 25 Jun 2007 16:21:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hw_random: add quality categories
Message-Id: <20070625162156.18c1abba.akpm@linux-foundation.org>
In-Reply-To: <200706241555.22957.mb@bu3sch.de>
References: <200706241555.22957.mb@bu3sch.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jun 2007 15:55:22 +0200
Michael Buesch <mb@bu3sch.de> wrote:

> The qualities of the HWRNGs are different from each other.
> So the current default policy of the hwrng core to default
> to the first found RNG is broken. This changes the default
> policy to select the RNG with the best quality category.
> So for a machine with a bcm43xx and a RNG in the CPU it
> would always default to the RNG in the CPU, as that's the
> better one.
> Of course, the selection can still be changed from userspace.

I'm presently having git disasters with the wireless tree and am unable to
include it in the -mm lineup so the hunk against
drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c doesn't apply here.

I stuck that change into a second patch and commented it out.  I will
hopefully remember to bring that patch back when git-wireless gets sorted
out.

