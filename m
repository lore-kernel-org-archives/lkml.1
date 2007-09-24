Return-Path: <linux-kernel-owner+w=401wt.eu-S1759380AbXIXPjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759380AbXIXPjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 11:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757835AbXIXPjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 11:39:24 -0400
Received: from gir.skynet.ie ([193.1.99.77]:39858 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755947AbXIXPjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 11:39:23 -0400
Date: Mon, 24 Sep 2007 16:39:21 +0100
To: Chris Holvenstot <cholvenstot@comcast.net>
Cc: kernel list <linux-kernel@vger.kernel.org>, dwmw2@infradead.org
Subject: Re: Mask Issue?
Message-ID: <20070924153920.GB32550@skynet.ie>
References: <1190242676.16474.6.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1190242676.16474.6.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (19/09/07 17:57), Chris Holvenstot didst pronounce:
> Still being a little new at this I am not sure if this is an issue at
> all or not but I noted that while building the 2.6.23-rc6-git8 kernel
> this afternoon I received the following error message: 
> 
> Building modules, stage 2.
>   MODPOST 1670 modules
> WARNING: Can't handle masks in drivers/mtd/nand/cafe_nand:FFFF0
> 
> I have been building each of the kernels in the 2.6.23-rc series and had
> not noted this message before.  I apologize if this is a non-issue.
> 

I noticed this in a -mm recently and never got around to kicking it
properly because I suspected it was a compiler issue. What version
of gcc and binutils are you using?

David Woodhouse added to cc in case this is a known problem.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
