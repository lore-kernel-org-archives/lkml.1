Return-Path: <linux-kernel-owner+w=401wt.eu-S933658AbZIDQh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933658AbZIDQh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 12:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932781AbZIDQh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 12:37:26 -0400
Received: from ru.mvista.com ([213.79.90.228]:9298 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932404AbZIDQhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 12:37:25 -0400
Date: Fri, 4 Sep 2009 20:37:27 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       spi-devel-general@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH v2 0/8] spi_mpc8xxx: Add support for DMA transfers
Message-ID: <20090904163727.GA27358@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090818220304.GA23640@oksana.dev.rtsoft.ru>
 <200908272141.59796.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200908272141.59796.david-b@pacbell.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 09:41:59PM -0700, David Brownell wrote:
> On Tuesday 18 August 2009, Anton Vorontsov wrote:
> 
> > - Fix build issues in fsl_qe_udc;
> > - Some minor cosmetic changes in "Add support for QE DMA mode and
> >   CPM1/CPM2 chips" patch.
> 
> Hmm ... the first four of these are pure PPC stuff and thus
> not appropriate to send as SPI patches; but the second four
> depend on them.
> 
> So I'll just say
> 
>   Acked-by: David Brownell <dbrownell@users.sourceforge.net>
> 
> and ask you to merge via the PPC tree.  (And hope that you
> verified these are bisectable...)

Thanks David.

Kumar, can you please merge the SPI part of this patch set?

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
