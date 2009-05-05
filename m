Return-Path: <linux-kernel-owner+w=401wt.eu-S1755919AbZEEQgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbZEEQgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 12:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753462AbZEEQgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 12:36:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:44721 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976AbZEEQgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 12:36:11 -0400
Date: Tue, 5 May 2009 09:31:53 -0700
From: Greg KH <gregkh@suse.de>
To: Nick Piggin <npiggin@suse.de>
Cc: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, San Mehat <san@android.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/7] lowmemorykiller: Only iterate over process list
	when needed.
Message-ID: <20090505163153.GA30292@suse.de>
References: <alpine.DEB.2.00.0905041722040.11756@chino.kir.corp.google.com> <20090505102359.GD28917@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090505102359.GD28917@wotan.suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 05, 2009 at 12:23:59PM +0200, Nick Piggin wrote:
> On Mon, May 04, 2009 at 05:26:50PM -0700, David Rientjes wrote:
> > From: Arve Hjønnevåg <arve@android.com>
> > 
> > Use NR_ACTIVE plus NR_INACTIVE as a size estimate for our fake cache
> > instead the sum of rss. Neither method is accurate.
> > 
> > Also skip the process scan, if the amount of memory available is above
> > the largest threshold set.
> > 
> > Signed-off-by: Arve Hjønnevåg <arve@android.com>
> 
> Didn't really look at the android stuff because I didn't even know
> it was there before. But I asume it is going to be "submitted" to
> the kernel proper at some stage (by some means other than a git rename) :)

Yes it will, when everyone agrees that what it is doing is the "right"
think to do :)

But for now, it sits in staging, as there are a few hundred thousand
devices using it...

thanks,

greg k-h
