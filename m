Return-Path: <linux-kernel-owner+w=401wt.eu-S1760875AbZFXQfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760875AbZFXQfe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 12:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759255AbZFXQf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 12:35:26 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:45961 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbZFXQfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 12:35:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SyEYNQvzZL2y0JRA0hJ8rF5tsdK2Y1EIWk5at3TRySexN2DnlOxwyWNUvdWMwqjgEW
         qHFgzqBbmBMYaT0BPHVl76L8Snb9JJ+vXg+7n2irYniDUR00NdF/7FfL0DtFd+kSM0K0
         W5bumZKMKS5k36toPcUKtCjqQQvJl5HpzSgqc=
Date: Wed, 24 Jun 2009 18:35:22 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Joel Becker <Joel.Becker@oracle.com>, Len Brown <lenb@kernel.org>,
       Avi Kivity <avi@qumranet.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Jens Axboe <jens.axboe@oracle.com>, Alasdair G Kergon <agk@redhat.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Richard Purdie <rpurdie@rpsys.net>, Boaz Harrosh <bharrosh@panasas.com>,
       Jon Masters <jonathan@jonmasters.org>, Greg KH <greg@kroah.com>
Subject: Re: Main things left in linux-next
Message-ID: <20090624163521.GA5996@nowhere>
References: <20090624164617.b7c49974.sfr@canb.auug.org.au> <20090624172735.9b500674.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624172735.9b500674.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 05:27:35PM +1000, Stephen Rothwell wrote:
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



Yeah, this one is not enough ready. I have yet
some cases in which performances are a bit less than
with the bkl, for example with only one thread writer.

So there is still a bit of work, I plan it for .32
You can remove it from next since it is based on a .30-rc
release. I will soon provide a rebased tree once -rc1 is released.


Thanks.



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
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/



