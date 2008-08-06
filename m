Return-Path: <linux-kernel-owner+w=401wt.eu-S1757621AbYHGAJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621AbYHGAJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 20:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbYHGAIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 20:08:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:56687 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbYHGAIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 20:08:31 -0400
Date: Wed, 6 Aug 2008 16:52:37 -0700
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Dave Hansen <haveblue@us.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix verify_dynamic_kobject_allocation()
Message-ID: <20080806235237.GA11964@kroah.com>
References: <Pine.LNX.4.44L0.0808061558320.2138-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0808061558320.2138-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 04:00:18PM -0400, Alan Stern wrote:
> The warn-when-statically-allocated-kobjects-are-used patch crashes my
> machine during boot when it calls kzalloc(), presumably because the
> call occurs too early.  This patch (as1126) fixes it by using a static
> string instead of a dynamically-allocated string.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

I just took andrew's version of this patch, sorry for the oops.

thanks,

greg k-h
