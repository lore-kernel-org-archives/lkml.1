Return-Path: <linux-kernel-owner+w=401wt.eu-S1754665AbZJEVOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbZJEVOQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 17:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753930AbZJEVOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 17:14:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49010 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753671AbZJEVOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 17:14:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 21/21] drivers/net/tlan.h: Convert printk(KERN_DEBUG to pr_dbg(
Date: Mon, 5 Oct 2009 23:15:01 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc2-rjw; KDE/4.3.1; x86_64; ; )
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       chessman@tux.org, netdev@vger.kernel.org
References: <cover.1254701151.git.joe@perches.com> <20091005.001240.111554671.davem@davemloft.net> <1254726974.1799.315.camel@Joe-Laptop.home>
In-Reply-To: <1254726974.1799.315.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200910052315.01357.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 October 2009, Joe Perches wrote:
> On Mon, 2009-10-05 at 00:12 -0700, David Miller wrote:
> > From: Joe Perches <joe@perches.com>
> > Date: Sun,  4 Oct 2009 17:53:48 -0700
> > > Removed "TLAN: " prefix from debug printks, it's added by pr_fmt
> > > Signed-off-by: Joe Perches <joe@perches.com>
> > Applied to net-next-2.6
> 
> Patches 20 and 21 depend on patch 1, which introduces pr_dbg
> to kernel.h.  Compile failure otherwise.

Why don't you push the first patch first, then, and wait with the others until
it gets merged?  This way individual subsystem maintainers will be able to
merge them cleanly.

Rafael
