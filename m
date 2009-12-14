Return-Path: <linux-kernel-owner+w=401wt.eu-S1757516AbZLNPT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516AbZLNPT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 10:19:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757500AbZLNPT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 10:19:28 -0500
Received: from kroah.org ([198.145.64.141]:50388 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634AbZLNPT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 10:19:27 -0500
Date: Mon, 14 Dec 2009 07:18:09 -0800
From: Greg KH <greg@kroah.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: ngupta@vflare.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ramzswap: remove ARM specific d-cache hack
Message-ID: <20091214151809.GA16209@kroah.com>
References: <1260598486-12623-1-git-send-email-ngupta@vflare.org> <84144f020912112341jc7fdc1eqac719578e2aa746b@mail.gmail.com> <4B2441A6.5050404@vflare.org> <84144f020912131236m2739aaa5obe6f8399d9e90aea@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020912131236m2739aaa5obe6f8399d9e90aea@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 13, 2009 at 10:36:26PM +0200, Pekka Enberg wrote:
> On Sun, Dec 13, 2009 at 3:21 AM, Nitin Gupta <ngupta@vflare.org> wrote:
> > On 12/12/2009 01:11 PM, Pekka Enberg wrote:
> >> On Sat, Dec 12, 2009 at 8:14 AM, Nitin Gupta <ngupta@vflare.org> wrote:
> >>> Remove d-cache hack in ramzswap driver that was needed
> >>> to workaround a bug in ARM version of update_mmu_cache()
> >>> which caused stale data in d-cache to be transferred to
> >>> userspace. This bug was fixed by git commit:
> >>> ? ? ? ?787b2faadc4356b6c2c71feb42fb944fece9a12f
> >>> This also brings down one entry in TODO file.
> >>>
> >>> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
> >>
> >> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
> >
> > Thanks for review Pekka.
> > Now wondering when this patch will be committed to mainline.
> 
> I don't see any reason why this shouldn't go into .33 but that's
> really up to Greg.

It will end up there, thanks, I will queue it up in a few days to go
there.

thanks,

greg k-h
