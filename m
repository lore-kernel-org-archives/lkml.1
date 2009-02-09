Return-Path: <linux-kernel-owner+w=401wt.eu-S1756589AbZBIS5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbZBIS5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 13:57:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbZBIS51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 13:57:27 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:34843 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030AbZBIS50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 13:57:26 -0500
Date: Mon, 9 Feb 2009 13:57:21 -0500
From: Andres Salomon <dilinger@queued.net>
To: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, j@mx08.poczta.interia.pl,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       adaplas@gmail.com
Subject: Re: [Linux-fbdev-devel] [PATCH 8/15] stifb: check fb_alloc_cmap
 return value and handle failure properly
Message-ID: <20090209135721.1db97470@ephemeral>
In-Reply-To: <20090209180549.cb07d0fb.krzysztof.h1@wp.pl>
References: <20090207121506.427d1cd8@ephemeral>
	<20090209180549.cb07d0fb.krzysztof.h1@wp.pl>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Feb 2009 18:05:49 +0100
Krzysztof Helt <krzysztof.h1@wp.pl> wrote:

> On Sat, 7 Feb 2009 12:15:06 -0500
> Andres Salomon <dilinger@queued.net> wrote:
> 
> > 
> > Signed-off-by: Andres Salomon <dilinger@debian.org>
> > ---
> 
> Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
> 
> I feel something is not right with the driver if memory 
> region (info->screen_base) is io mapped first then
> reserved with request_mem_region().
> 
> Regards,
> Krzysztof

Yeah, I noticed quite a few other bugs while going through cmap brokenness,
and I'm not even done w/ the cmap stuff yet.  I figured I'd do one thing at
a time.

Thanks for the Acks!
