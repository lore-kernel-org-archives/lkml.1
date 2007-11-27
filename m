Return-Path: <linux-kernel-owner+w=401wt.eu-S1756654AbXK0SLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654AbXK0SLY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 13:11:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756076AbXK0SLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 13:11:16 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33890 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005AbXK0SLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 13:11:15 -0500
Date: Tue, 27 Nov 2007 10:07:42 -0800
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Kobjects: drop child->parent ref at unregistration
Message-ID: <20071127180742.GA2768@kroah.com>
References: <20071127170147.GB29109@kroah.com> <Pine.LNX.4.44L0.0711271235430.3037-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0711271235430.3037-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2007 at 12:41:23PM -0500, Alan Stern wrote:
> On Tue, 27 Nov 2007, Greg KH wrote:
> 
> > For now, I'd recommend dropping it from your tree Andrew, as it might
> > cause odd issues on device removal (not quite sure though...)
> 
> But then there's the counter-argument: If the patch does cause any odd 
> issues to shake loose, learning about them in advance by exposing the 
> patch in the -mm tree would be worthwhile.
> 
> Sounds like it's time for an executive decision...  :-)

Heh.  I'm not ignoring the patch, and will apply it if I test it out and
see that it doesn't break anything.  Then I will let it bake in -mm for
a while.

I just don't want to rush it as this area of the kobject core is nasty
and full of tricks that I always forget.

Let me finish writing up this documentation on what I do remember and
then I'll attack the block device patch and this one.

thanks,

greg k-h
