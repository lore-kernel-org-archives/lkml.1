Return-Path: <linux-kernel-owner+w=401wt.eu-S933624AbXCSCJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933624AbXCSCJG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 22:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933652AbXCSCJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 22:09:06 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:41559 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933624AbXCSCJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 22:09:04 -0400
Date: Mon, 19 Mar 2007 00:44:43 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix build error due to not including <linux/errno.h>
Message-ID: <20070319004443.GA25164@linux-mips.org>
References: <20070318125808.GA25840@linux-mips.org> <Pine.LNX.4.44L0.0703182036060.17900-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0703182036060.17900-100000@netrider.rowland.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2007 at 08:36:48PM -0400, Alan Stern wrote:

> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> 
> Thank you for spotting and fixing this.

It's the second time I've fixed a CONFIG_SYSFS=n bug.  Of course that
sort of thing just shouldn't happen - but the fact that in both cases
the bug wasn't noticed for a few days makes me wonder if we simply should
always enable CONFIG_SYSFS at some point.

  Ralf
