Return-Path: <linux-kernel-owner+w=401wt.eu-S1755647AbZFXHsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbZFXHsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 03:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755197AbZFXHsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 03:48:00 -0400
Received: from brick.kernel.dk ([93.163.65.50]:49526 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753783AbZFXHr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 03:47:59 -0400
Date: Wed, 24 Jun 2009 09:48:01 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Joel Becker <Joel.Becker@oracle.com>,
       =?iso-8859-1?B?IkZy6WTpcmljIFdlaXNiZWNrZXIi?= <fweisbec@gmail.com>,
       Len Brown <lenb@kernel.org>, Avi Kivity <avi@qumranet.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alasdair G Kergon <agk@redhat.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Richard Purdie <rpurdie@rpsys.net>, Boaz Harrosh <bharrosh@panasas.com>,
       Jon Masters <jonathan@jonmasters.org>, Greg KH <greg@kroah.com>
Subject: Re: Main things left in linux-next
Message-ID: <20090624074801.GH31415@kernel.dk>
References: <20090624164617.b7c49974.sfr@canb.auug.org.au> <20090624172735.9b500674.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624172735.9b500674.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24 2009, Stephen Rothwell wrote:
> Hi All,
> 
> $ git diff --shortstat -M stable..HEAD^
>  587 files changed, 27313 insertions(+), 12317 deletions(-)
> 
> We seem to be going backwards :-( Yesterday's was:
>  556 files changed, 27596 insertions(+), 7123 deletions(-)
> 
> $ git diff --dirstat -M stable..HEAD^
>    4.9% Documentation/powerpc/dts-bindings/
>    5.1% Documentation/powerpc/
>    3.0% Documentation/vm/
>    3.9% arch/sparc/
>    3.9% arch/x86/kvm/
>    4.4% arch/x86/
>    6.9% drivers/md/
>    4.7% drivers/misc/
>    9.8% drivers/staging/et131x/
>    4.3% drivers/staging/
>    6.6% drivers/usb/otg/
>   14.5% drivers/
>    5.5% include/linux/
>   12.6% mm/
> 
> The main obvious things left are:
> 
> SLQB from the slab tree
> an m68k update
> an ocfs2 update
> the reiserfs kill-the-bkl effort
> an acpi update
> a kvm update
> some more cpumask work from the rr tree
> the writeback changes form the block tree
> a device-mapper update
> a battery tree update
> a leds tree update
> osdblk from the osd tree
> the new hwlat tree
> devtmpfs from the driver-core tree (hmmm?)
> 
> Please do not shoot the messenger. :-)

The writeback changes will be sitting there until .32 :-)

-- 
Jens Axboe

