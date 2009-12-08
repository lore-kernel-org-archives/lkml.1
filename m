Return-Path: <linux-kernel-owner+w=401wt.eu-S1753784AbZLHHOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784AbZLHHOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 02:14:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbZLHHON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 02:14:13 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:42048 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbZLHHOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 02:14:12 -0500
Date: Tue, 8 Dec 2009 16:13:02 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
       Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
Subject: Re: [PATCH 5/5] sh: dmaengine support for sh7724
Message-ID: <20091208071302.GA23814@linux-sh.org>
References: <Pine.LNX.4.64.0912041936541.3981@axis700.grange> <Pine.LNX.4.64.0912041942330.3981@axis700.grange> <e9c3a7c20912071702h1aea2026kff22db99a221f6c4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9c3a7c20912071702h1aea2026kff22db99a221f6c4@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 06:02:24PM -0700, Dan Williams wrote:
> On Fri, Dec 4, 2009 at 11:45 AM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > Add a dmaengine platform device to sh7724, fix DMA channel interrupt numbers.
> >
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> >
> > With this patch dmatest works with channels 0-5, channels 6-11 still don't
> > work for some reason... So, feel free to discard it for now, if a complete
> > fix would be preferred.
> 
> Does this patch limit operation to channels 0-5?  I leave this one for
> Paul to disposition.
> 
There are 6 channels per controller, so the fact that the second
controller isn't working could either be cause the driver needs more work
to handle multiple controllers properly, or there could be a pinmux issue
that hasn't been resolved yet for DMAC1. Both of these cases require the
driver to be a bit smarter, but as Guennadi is presently working on these
things, doing them incrementally is ok with me. If this gets DMAC0
working at least where it wasn't before, it's certainly worth applying.
DMAC1 seems to have more problems than just wrong interrupt numbers, so
this isn't going to cause any regressions there either.

Acked-by: Paul Mundt <lethal@linux-sh.org>
