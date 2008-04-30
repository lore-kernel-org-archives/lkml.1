Return-Path: <linux-kernel-owner+w=401wt.eu-S1755361AbYD3CCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbYD3CCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 22:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754516AbYD3CCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 22:02:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56218 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757542AbYD3CB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 22:01:57 -0400
Date: Tue, 29 Apr 2008 23:00:40 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: upstream build failure: v4l/dvb
Message-ID: <20080429230040.45fc6a96@gaivota>
In-Reply-To: <20080430114124.45017177.sfr@canb.auug.org.au>
References: <20080430114124.45017177.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Wed, 30 Apr 2008 11:41:24 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> Today's linux-next build (Linus' tree, x86_64 allmodconfig) fails like
> this:
> 
> ERROR: "tea5767_autodetection" [drivers/media/video/tuner.ko] undefined!
> ERROR: "tda829x_probe" [drivers/media/video/tuner.ko] undefined!
> ERROR: "tea5761_autodetection" [drivers/media/video/tuner.ko] undefined!

I suspect that something wrong happened on your compilation, or at linux-next
merge. Those three drivers (tea5767, tea5761 and tea829x) were moved
from /drivers/media/video to /drivers/common/tuners, but the above messages are
pointing to the old path.
 
> Also, note that this commit has no Signed-off-by ...

Ops. Sorry. How could I forgot to sign a patch!

Just for the records: Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>


Cheers,
Mauro
