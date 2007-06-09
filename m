Return-Path: <linux-kernel-owner+w=401wt.eu-S1758796AbXFITKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758796AbXFITKp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 15:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757056AbXFITKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 15:10:36 -0400
Received: from waste.org ([66.93.16.53]:39923 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998AbXFITKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 15:10:35 -0400
Date: Sat, 9 Jun 2007 14:10:10 -0500
From: Matt Mackall <mpm@selenic.com>
To: Bernd Schmidt <bernds_cb1@t-online.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>, "Wu, Bryan" <Bryan.Wu@analog.com>
Subject: Re: [PATCH, RFD]: Unbreak no-mmu mmap
Message-ID: <20070609191010.GB11166@waste.org>
References: <46695F6D.5050600@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46695F6D.5050600@t-online.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 03:53:49PM +0200, Bernd Schmidt wrote:
> 2. It is no longer possible to get blocks smaller than a page through
>    mmap.  This behaviour was used by simplemalloc, which is an insane
>    way of implementing malloc on nommu systems and hopefully not used
>    by anyone anymore.

That's worrisome. Breaking existing apps/libraries seems like a bad
idea.

-- 
Mathematics is the supreme nostalgia of our time.
