Return-Path: <linux-kernel-owner+w=401wt.eu-S1751229AbXBUMCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751229AbXBUMCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 07:02:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbXBUMCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 07:02:49 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38618 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751229AbXBUMCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 07:02:48 -0500
Date: Wed, 21 Feb 2007 13:02:47 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] videobuf_qbuf: fix? possible videobuf_queue->stream corruption and lockup
Message-ID: <20070221120247.GL13958@stusta.de>
References: <20070123175714.GA299@tv-sign.ru> <1169593808.18437.4.camel@areia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1169593808.18437.4.camel@areia>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 23, 2007 at 09:10:08PM -0200, Mauro Carvalho Chehab wrote:
> Em Ter, 2007-01-23 às 20:57 +0300, Oleg Nesterov escreveu:
> > I am pretty sure the bug is real, but the patch may be wrong, please review.
> > 
> > We are doing ->buf_prepare(buf) before adding buf to q->stream list. This
> > means that videobuf_qbuf() should not try to re-add a STATE_PREPARED buffer.
> > 
> > Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
> 
> Chris/Adrian,
> 
> IMO, this should also be applied at -stable trees.
>...

Thanks, applied to 2.6.16 (a trivial backport was required since the 
dprintk() was added after 2.6.16).

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

