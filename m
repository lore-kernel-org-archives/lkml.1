Return-Path: <linux-kernel-owner+w=401wt.eu-S1761974AbZJNQOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761974AbZJNQOY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 12:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761719AbZJNQOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 12:14:24 -0400
Received: from kroah.org ([198.145.64.141]:34807 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760600AbZJNQOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 12:14:23 -0400
Date: Wed, 14 Oct 2009 09:10:55 -0700
From: Greg KH <greg@kroah.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] compat_ioctl: remove VT specific ioctl handlers
Message-ID: <20091014161055.GA9932@kroah.com>
References: <20091010153314.827301943@linutronix.de>
 <200910141759.35162.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910141759.35162.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 05:59:34PM +0200, Arnd Bergmann wrote:
> The VT driver now handles all of these ioctls directly, so
> we can remove the handlers from common code.
> 
> These are the only handlers that require the BKL because they
> directly perform the ioctl action rather than just converting
> the data structures. Once they are gone, we can remove the
> BKL from the remaining ioctl conversion handlers.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  fs/compat_ioctl.c |  188 +----------------------------------------------------
>  1 files changed, 1 insertions(+), 187 deletions(-)
> 
> I guess it makes sense to merge these two through the BKL removal
> queue.

That's fine with me:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

thanks,

greg k-h
