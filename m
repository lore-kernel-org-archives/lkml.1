Return-Path: <linux-kernel-owner+w=401wt.eu-S1759065AbYCXLWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759065AbYCXLWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 07:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757957AbYCXLV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 07:21:58 -0400
Received: from lazybastard.de ([212.112.238.170]:59723 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757611AbYCXLV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 07:21:57 -0400
Date: Mon, 24 Mar 2008 12:21:31 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Adrian McMenamin <adrian@newgolddream.dyndns.info>,
       dwmw2 <dwmw2@infradead.org>, Andrew Morton <akpm@osdl.org>,
       linux-sh <linux-sh@vger.kernel.org>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>,
       MTD <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH] 2/3 mtd: add support for flash on the SEGA Dreamcast Visual Memory Unit
Message-ID: <20080324112131.GA2392@logfs.org>
References: <1206207805.6324.13.camel@localhost.localdomain> <1206209035.6324.29.camel@localhost.localdomain> <20080322183200.GD19347@logfs.org> <1206211147.6324.48.camel@localhost.localdomain> <20080322185600.GE19347@logfs.org> <1206207805.6324.13.camel@localhost.localdomain> <1206209035.6324.29.camel@localhost.localdomain> <20080322183200.GD19347@logfs.org> <1206211147.6324.48.camel@localhost.localdomain> <20080324020832.GA13935@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080324020832.GA13935@linux-sh.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 March 2008 11:08:32 +0900, Paul Mundt wrote:
>
> I've hit the same issues with Adrian's patches in the past, but I've
> weighed this against a couple of factors:
> 
> 	- Is it reasonably isolated.
> 	- Does it break anything else.
> 	- Is it more likely to get pointed at and fixed in-tree or out.

I tend to agree with one condition: There needs to be a prospect of
improvement.  My two preferred variants would be one person doing
everything or two people, one improving the code and the other testing
on hardware to detect and prevent regressions.

For a moment I was contemplating just taking the mtd driver and doing
the work myself.  But two things stopped me short.  For one, I didn't
find the referenced header anywhere.  Secondly I lack any hardware to
test the result.

But more to the point, I cannot come to terms with Adrian.  So either
one of us has to be replaced - and I cannot see a lot of volunteers - or
we are currently lacking the prospect of improvement.  Hence my bad
feeling about this code.

Hopefully I just caught Adrian on the wrong foot.

> With that said, the current code obviously needs quite a bit of work
> before it can be merged. I'm obviously coming in to this thread late, so
> it would be helpful to have a pointer to the initial review comments.

Thread starts here:
http://lists.infradead.org/pipermail/linux-mtd/2008-March/020880.html

Jörn

-- 
Those who come seeking peace without a treaty are plotting.
-- Sun Tzu
