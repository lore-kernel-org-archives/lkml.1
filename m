Return-Path: <linux-kernel-owner+w=401wt.eu-S934891AbXK3Dlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934891AbXK3Dlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 22:41:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759338AbXK3Dlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 22:41:42 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34878 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbXK3Dll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 22:41:41 -0500
Date: Thu, 29 Nov 2007 19:40:27 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Chris Snook <csnook@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Avoid overflows in kernel/time.c
Message-ID: <20071129194027.10046988@laptopd505.fenrus.org>
In-Reply-To: <474F7DC4.8000607@zytor.com>
References: <200711300019.lAU0Jpbr003807@tazenda.hos.anvin.org>
	<474F6E7A.3090705@redhat.com>
	<474F7DC4.8000607@zytor.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 19:04:36 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> Chris Snook wrote:
> > H. Peter Anvin wrote:
> >> NOTE: This patch uses a bc(1) script to compute the appropriate
> >> constants.
> > 
> > Perhaps dc would be more appropriate?  That's included in busybox.
> > 
> 
> Perhaps it would, but I think there is more variability between dc 
> implementations -- consider if the busybox version is broken, for
> eample.
> 
> Either way, how many people compile their kernels in a busybox
> environment?
> 
> Anyway, I don't think compiling bc is hard on anything which has a C 
> compiler.

alternative is to just also ship the precomputed values ;-)

> 
> 	-hpa
> -
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
