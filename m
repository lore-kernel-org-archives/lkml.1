Return-Path: <linux-kernel-owner+w=401wt.eu-S1759615AbZDGBKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759615AbZDGBKA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 21:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbZDGBJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 21:09:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:39997 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbZDGBJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 21:09:50 -0400
Subject: Re: intel-iommu: Add for_each_iommu() and for_each_active_iommu()
 macros
From: David Woodhouse <dwmw2@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20090406175918.c38654b2.akpm@linux-foundation.org>
References: <200904062159.n36Lx1OJ001967@hera.kernel.org>
	 <20090406175918.c38654b2.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 06 Apr 2009 18:09:43 -0700
Message-Id: <1239066583.22733.258.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 (2.26.0-2.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-06 at 17:59 -0700, Andrew Morton wrote:
> 
> Three days old?  Never been in linux-next afaict.
> 
> Please don't do that.

Sorry about that. There was some confusion about whether it was going
via Ingo's or my tree, and it ended up in neither. It depended on
certain things in Ingo's tree, so I couldn't easily add it to my tree
any earlier.

I'm unconvinced by the fix -- can we find a way to fix the if() macro so
that normal (if fugly) C code like this doesn't doesn't need this kind
of workaround?

(Yes, it's fugly. But the original was worse IMHO:
https://lists.linux-foundation.org/pipermail/iommu/attachments/20090327/31f84f7d/attachment.txt )

-- 
dwmw2

