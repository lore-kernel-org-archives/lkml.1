Return-Path: <linux-kernel-owner+w=401wt.eu-S1754654AbXLURgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbXLURgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 12:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039AbXLURgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 12:36:15 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:1865 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbXLURgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 12:36:14 -0500
Date: Fri, 21 Dec 2007 17:36:01 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
       linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] SC26XX: New serial driver for SC2681 uarts
Message-ID: <20071221173601.GR13186@shadowen.org>
References: <20071202194346.36E3FDE4C4@solo.franken.de> <20071203155317.772231f9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071203155317.772231f9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2007 at 03:53:17PM -0800, Andrew Morton wrote:
> > +#define READ_SC(p, r)        readb ((p)->membase + RD_##r)
> > +#define WRITE_SC(p, r, v)    writeb ((v), (p)->membase + WR_##r)
> 
> No space before the (.  checkpatch misses this.

Yep, over careful in the special case for the parameters for #define
macros, which have different spacing rules.  This will be fixed in 0.13:

WARNING: no space between function name and open parenthesis '('
#1: FILE: Z45.c:1:
+#define WRITE_SC(p, r, v)    writeb ((v), (p)->membase + WR_##r)

-apw
