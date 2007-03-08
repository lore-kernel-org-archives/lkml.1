Return-Path: <linux-kernel-owner+w=401wt.eu-S1030284AbXCHIfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030284AbXCHIfz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 03:35:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030288AbXCHIfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 03:35:55 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41846 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030284AbXCHIfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 03:35:54 -0500
Date: Thu, 8 Mar 2007 08:35:43 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Christoph Hellwig <hch@infradead.org>, Deepak Saxena <dsaxena@plexity.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix building kernel under Solaris
Message-ID: <20070308083543.GA5213@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Deepak Saxena <dsaxena@plexity.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20070306180940.GA3240@plexity.net> <20070307094229.GG14863@infradead.org> <Pine.LNX.4.61.0703072342310.2448@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0703072342310.2448@yvahk01.tjqt.qr>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 11:45:11PM +0100, Jan Engelhardt wrote:
> 
> On Mar 7 2007 09:42, Christoph Hellwig wrote:
> >>  #include <sys/time.h>
> >>  #include <sys/ioctl.h>
> >>  #include <sys/types.h>
> >> +#ifndef __sun__
> >>  #include <asm/types.h>
> >>  #endif
> >> +#endif
> >
> >So if solaris doesn't need it, why do we need it on Linux?
> 
> For __s32 and __s16.

We shouldn't use those from asm/types.h on Linux either, but
get them consitantly by defining them to the C99 or BSD types
from the libc headers.
