Return-Path: <linux-kernel-owner+w=401wt.eu-S1760383AbZEMOmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760383AbZEMOmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 10:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756767AbZEMOmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 10:42:05 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:37231 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602AbZEMOmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 10:42:04 -0400
Date: Wed, 13 May 2009 16:41:59 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb-serial: ftdi: don't dereference NULL pointer
Message-ID: <20090513144159.GI32424@buzzloop.caiaq.de>
References: <1242213703-3004-1-git-send-email-daniel@caiaq.de> <20090513143536.GA3443@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090513143536.GA3443@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 07:35:36AM -0700, Greg KH wrote:
> On Wed, May 13, 2009 at 01:21:43PM +0200, Daniel Mack wrote:
> > The FTDI USB serial driver dereferences its priv structure in
> > ftdi_close() without checking for NULL pointer conditions, see the Oops
> > attached.
> 
> Hm, I think this was already resolved with Alan's patch that went in
> right after 2.6.30-rc5 came out. 

That was a similiar issue, yes. But it occured under different
circumstances, not under the condition I described.

> Can you check Linus's current tree to
> see if we still need this patch or not?

Is is needed, yes. I'm working on Linus' git as of this morning, so I'm
cutting edge mainline and can still perfectly reproduce the problem.

Not anymore with my patch, though.

Daniel

