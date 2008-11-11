Return-Path: <linux-kernel-owner+w=401wt.eu-S1755541AbYKKHhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbYKKHhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 02:37:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754694AbYKKHg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 02:36:56 -0500
Received: from kroah.org ([198.145.64.141]:60326 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752445AbYKKHgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 02:36:55 -0500
Date: Mon, 10 Nov 2008 23:32:37 -0800
From: Greg KH <greg@kroah.com>
To: David Miller <davem@davemloft.net>
Cc: miklos@szeredi.hu, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       a.bittau@cs.ucl.ac.uk, stable@kernel.org, viro@ZenIV.linux.org.uk,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       adobriyan@gmail.com
Subject: Re: [stable] [patch] net: unix: fix inflight counting bug in
	garbage collector
Message-ID: <20081111073237.GA13973@kroah.com>
References: <E1KzBCn-00062L-Fp@pomaz-ex.szeredi.hu> <20081110.225938.79412569.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081110.225938.79412569.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2008 at 10:59:38PM -0800, David Miller wrote:
> From: Miklos Szeredi <miklos@szeredi.hu>
> Date: Sun, 09 Nov 2008 15:23:57 +0100
> 
> > This patch fixes the BUG_ON triggered by Andrea's tests.  It turned
> > out to be completely independent of the stack overflow issue, but
> > happens to be triggered by the same test program.
> > 
> > Should qualify for -stable too.
> 
> Miklos thanks a lot for fixing this.  And Linus thanks for
> queueing this up to 2.6.28-rc4
> 
> Stable folks, please include this in -stable as soon as you
> can, since the BUG can be triggered by local users.

Thanks, will do.

greg k-h
