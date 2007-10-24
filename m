Return-Path: <linux-kernel-owner+w=401wt.eu-S1760551AbXJXOg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760551AbXJXOg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 10:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759707AbXJXOev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 10:34:51 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:49509 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760252AbXJXOes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 10:34:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:in-reply-to:references:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=TpMxZQTEFjZRZvBPOA8+LL9J8IClee5b3WA+VlDJ3L7WvgnG7cZbhM4tce0LGBcSi7m0SXVT+DFtk9CL/Ovowv2ISCcXWGlEYlsZvsjk3HvcmRJXpA3Ce/IbSy5VvSYhY1RLbDFNjobK/L9r1ve2vT1MrVSaAqjufqqXinaPby8=
Date: Wed, 24 Oct 2007 16:34:42 -0700
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>,
       linux-main <linux-kernel@vger.kernel.org>,
       linuxsh <linuxsh-dev@lists.sourceforge.net>
Subject: Re: [SUPERH] dma-mapping.h structure has no member named page
Message-Id: <20071024163442.1e3e6998.Kristoffer.ericson@gmail.com>
In-Reply-To: <20071023230507.GP14671@kernel.dk>
References: <20071023185305.4fd9a084.Kristoffer.ericson@gmail.com>
	<20071023230507.GP14671@kernel.dk>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007 01:05:07 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Tue, Oct 23 2007, Kristoffer Ericson wrote:
> > Greetings,
> > 
> > Got this after syncing my tree with linux-2.6.git.
> > 
> > In file included from include/linux/dma-mapping.h:52,
> >                  from include/linux/dmaengine.h:29,
> >                  from include/linux/skbuff.h:29,
> >                  from include/linux/netlink.h:155,
> >                  from include/linux/genetlink.h:4,
> >                  from include/net/genetlink.h:4,
> >                  from include/linux/taskstats_kern.h:12,
> >                  from init/main.c:46:
> > include/asm/dma-mapping.h: In function `dma_map_sg':
> > include/asm/dma-mapping.h:88: error: structure has no member named `page'
> > include/asm/dma-mapping.h:91: error: structure has no member named `page'
> > include/asm/dma-mapping.h: In function `dma_sync_sg':
> > include/asm/dma-mapping.h:141: error: structure has no member named `page'
> > include/asm/dma-mapping.h:144: error: structure has no member named `page'
> > make[1]: *** [init/main.o] Error 1
> > make: *** [init] Error 2
> 
> Pull again, should be ok now.
Yeah, saw the posts on it last night. Everything worked fine after pulling again last night. Thx

> 
> -- 
> Jens Axboe
> 
