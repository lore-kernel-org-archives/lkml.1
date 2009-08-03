Return-Path: <linux-kernel-owner+w=401wt.eu-S1753866AbZHCBBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbZHCBBu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 21:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751653AbZHCBBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 21:01:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37669 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbZHCBBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 21:01:48 -0400
From: "NeilBrown" <neilb@suse.de>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
Date: Mon, 3 Aug 2009 11:01:24 +1000 (EST)
Message-ID: <7f7d2d5828c15f1fe8221554f661903e.squirrel@neil.brown.name>
In-Reply-To: <20090803103550.9b28900a.sfr@canb.auug.org.au>
References: <20090803103550.9b28900a.sfr@canb.auug.org.au>
Subject: Re: linux-next:  tree build failure
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Andre Noll" <maan@systemlinux.org>
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, August 3, 2009 10:35 am, Stephen Rothwell wrote:
> Hi Neil,
>
> Today's linux-next build (powerpc ppc64_defconfig) failed like this:
>
> ERROR: ".md_integrity_add_rdev" [drivers/md/multipath.ko] undefined!
>
> Caused by commit 66f4f3f41f5c334f399e920b2aaad9b82514acda ("md: Push down
> data integrity code to personalities") from the md-current and md trees.
> Looks like md_integrity_add_rdev needs an EXPORT_SYMBOL.

Yes, of course...
Thanks!
Fixed.

NeilBrown


>
> I have used the version of the md-current and md trees from next-20090731
> for today.
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>

