Return-Path: <linux-kernel-owner+w=401wt.eu-S1758560AbXEJI0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560AbXEJI0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 04:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757135AbXEJI02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 04:26:28 -0400
Received: from canuck.infradead.org ([209.217.80.40]:42760 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880AbXEJI01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 04:26:27 -0400
Subject: Re: [PATCH] Add LZO1X compression support to the kernel
From: David Woodhouse <dwmw2@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Purdie <richard@openedhand.com>,
       LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org
In-Reply-To: <20070509232129.371f49d5.akpm@linux-foundation.org>
References: <1178096183.5860.25.camel@localhost.localdomain>
	 <20070509232129.371f49d5.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 10 May 2007 09:26:16 +0100
Message-Id: <1178785576.28494.17.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7.dwmw2.2) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-09 at 23:21 -0700, Andrew Morton wrote:
> Well that's attractive-looking code.

It's compression code. I've never seen compression code look nice :)

> Why is this needed?  What code plans to use it?

I'm itching to use it in JFFS2. Richard claims a 10% boot time speedup
and 40% improvement on file read speed, with only a slight drop in the
file compression ratio (when compared to zlib).

> How many buffer overruns are there in it?

That I'm afraid I cannot tell you.

-- 
dwmw2

