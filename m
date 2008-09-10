Return-Path: <linux-kernel-owner+w=401wt.eu-S1754357AbYIJXFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357AbYIJXFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 19:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756277AbYIJXFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 19:05:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55228
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756232AbYIJXFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 19:05:11 -0400
Date: Wed, 10 Sep 2008 16:05:05 -0700 (PDT)
Message-Id: <20080910.160505.14060698.davem@davemloft.net>
To: dwmw2@infradead.org
Cc: jeffm@suse.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
From: David Miller <davem@davemloft.net>
In-Reply-To: <1221087719.13621.50.camel@macbook.infradead.org>
References: <48C68507.6000609@suse.com>
	<1221087719.13621.50.camel@macbook.infradead.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>
Date: Wed, 10 Sep 2008 16:01:59 -0700

> On Tue, 2008-09-09 at 10:15 -0400, Jeff Mahoney wrote:
> >  This patch moves them to /lib/firmware/$KERNELRELEASE. udev v127's
> >  firmware.sh looks there first before falling back to /lib/firmware.
> 
> NAK.
> 
> This isn't compatible with the version of udev that people actually have
> installed, today. And it's also the _wrong_ thing to do.
> 
> Firmware really _isn't_ version-specific.

Tell that to every Debian and Debian derived system on the planet.

To my knowledge, it is only fedora and possibly one or two other dists
that put the firmware files in a unary /lib/firmware location, rather
than a versioned /lib/firmware/$KERNELRELASE one.


