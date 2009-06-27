Return-Path: <linux-kernel-owner+w=401wt.eu-S1753596AbZF0JSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbZF0JSs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 05:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbZF0JSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 05:18:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:40077 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509AbZF0JSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 05:18:38 -0400
Subject: Re: [PATCH] IDE: ide-taskfile.c fix compilation warning and cleanup
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200906262142.43102.bzolnier@gmail.com>
References: <1245650973.30547.3.camel@ht.satnam>
	 <200906221250.36318.bzolnier@gmail.com>
	 <1245986290.3568.1.camel@hpdv5.satnam>
	 <200906262142.43102.bzolnier@gmail.com>
Content-Type: text/plain
Date: Sat, 27 Jun 2009 14:48:28 +0530
Message-Id: <1246094308.2961.15.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Bart, David,

On Fri, 2009-06-26 at 21:42 +0200, Bartlomiej Zolnierkiewicz wrote:
> On Friday 26 June 2009 05:18:10 Jaswinder Singh Rajput wrote:
> > On Mon, 2009-06-22 at 12:50 +0200, Bartlomiej Zolnierkiewicz wrote:
> 
> > > Besides I would suggest splitting the patch on fix and cleanup parts.
> > 
> > Here is the cleanup part:
> > 
> > [PATCH] IDE: ide-taskfile.c fix style problems
> > 
> > Fix trivial style problems:
> > 
> > WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
> > WARNING: space prohibited between function name and open parenthesis '('
> > WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
> > ERROR: do not use C99 // comments X 2
> > ERROR: trailing statements should be on next line
> > ERROR: trailing whitespace
> > ERROR: switch and case should be at the same indent
> > WARNING: line over 80 characters
> > 
> > total: 5 errors, 4 warnings
> > 
> > Also removed dead code
> > 
> > Also used pr_err() to avoid line breaks
> > 
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> 
> Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Thanks.

If you want I can also fix another ide files.

David, is it OK.

Please let me know which tree I should use bart or David.

Thanks,
--
JSR

