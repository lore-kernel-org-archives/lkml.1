Return-Path: <linux-kernel-owner+w=401wt.eu-S1758328AbXJLQfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758328AbXJLQfl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762255AbXJLQd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:33:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59306 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762246AbXJLQd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:33:28 -0400
Date: Fri, 12 Oct 2007 09:26:16 -0700
From: Greg KH <greg@kroah.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Subject: Re: [stable] [git patch] libata critical fix
Message-ID: <20071012162616.GA21137@kroah.com>
References: <20071012042515.GA17066@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071012042515.GA17066@havoc.gtf.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2007 at 12:25:15AM -0400, Jeff Garzik wrote:
> 
> There is a lingering corruption in sata_mv that took me several days to
> narrow down...  the failure to mask off the lower 16 bits of the S/G
> length was leading to corruption, because this stomped on other
> important bits in that S/G entry.
> 
> This should fix it (stable aka 2.6.23.1 needs this too):

I'm guessing that this is critical enough to do a 2.6.23.1 with this fix
in it right now.  Any objections to that?

thanks,

greg k-h
