Return-Path: <linux-kernel-owner+w=401wt.eu-S1762585AbYFLN6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762585AbYFLN6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 09:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759050AbYFLN6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 09:58:13 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:48889 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282AbYFLN6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 09:58:12 -0400
Date: Thu, 12 Jun 2008 15:58:10 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Pierre Ossman <drzeus@drzeus.cx>, linux-mips@linux-mips.org,
       sshtylyov@ru.mvista.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] Alchemy: register mmc platform device for
	db1200/pb1200 boards.
Message-ID: <20080612135810.GA25352@roarinelk.homelinux.net>
References: <20080609063521.GA8724@roarinelk.homelinux.net> <20080609063702.GC8724@roarinelk.homelinux.net> <20080612090206.GB21601@linux-mips.org> <20080612101839.GC21601@linux-mips.org> <20080612121828.GA24603@roarinelk.homelinux.net> <20080612122646.GA9493@linux-mips.org> <20080612154248.5c9c5c9d@mjolnir.drzeus.cx> <20080612134729.GA20015@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080612134729.GA20015@linux-mips.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 02:47:30PM +0100, Ralf Baechle wrote:
> On Thu, Jun 12, 2008 at 03:42:48PM +0200, Pierre Ossman wrote:
> 
> > > Pierre, feel free to merge these MIPS bits into your tree.  The whole
> > > series should probably go upstream together.
> > > 
> > 
> > How's the dependency issue though? Will this series be bisectable in my
> > tree?
> 
> If we're only talking about a build, there should be no dependencies
> between the Alchemy and the MMC parts of the series.  The Alchemy part
> sorts the device registration and that's a separate construction site
> from the rest.  Of course with only one applied things won't work
> terribly well but that would only be temporarily.

FWIW, I build tested-tested the DB1200 defconfig after each patch applied.
As Ralf said, patch 1 alone isn't terribly useful on it, but it should work.

	Manuel Lauss
