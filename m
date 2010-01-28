Return-Path: <linux-kernel-owner+w=401wt.eu-S1752925Ab0A1FyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab0A1FyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 00:54:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721Ab0A1FyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 00:54:08 -0500
Received: from kroah.org ([198.145.64.141]:48671 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980Ab0A1FyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 00:54:08 -0500
Date: Wed, 27 Jan 2010 21:54:11 -0800
From: Greg KH <greg@kroah.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3][resend] set block size to PAGE_SIZE and some
	cleanups
Message-ID: <20100128055411.GA8889@kroah.com>
References: <1264602246-12880-1-git-send-email-ngupta@vflare.org> <1264602246-12880-4-git-send-email-ngupta@vflare.org> <4B610BA6.2020009@vflare.org> <20100128042338.GA7004@kroah.com> <d760cf2d1001272137l3c4f7e48md37c3ea9ef509222@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d760cf2d1001272137l3c4f7e48md37c3ea9ef509222@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 11:07:20AM +0530, Nitin Gupta wrote:
> On Thu, Jan 28, 2010 at 9:53 AM, Greg KH <greg@kroah.com> wrote:
> > On Thu, Jan 28, 2010 at 09:29:34AM +0530, Nitin Gupta wrote:
> >> [replace stat_*() with rzs_stat*()]
> >> ---
> >>
> >> ramzswap block size needs to be set to PAGE_SIZE
> >> to avoid receiving any unaligned block I/O (happens
> >> during swapon time). These unaligned access produce
> >> unncessary I/O errors, scaring users.
> >>
> >> Also included some minor cleanups.
> >
> > Such as?
> >
> > Could you break this into 2 patches, one the block size stuff, and the
> > other the cleanups? ?Remember, 1 patch does 1 thing.
> >
> 
> I thought large number of patches is not desirable, so I merged lot
> of stuff in one. I will resend 'v2' patches with proper breakup.

Large numbers of patches is not only desirable, it is encouraged!  Bring
them on, I get patch series all the time that start out [00/34] and
that's just fine.

And actually, doing things in small chunks is better if a problem is
found, as smaller patches are easier to review, and 'git bisect' makes
it trivial to narrow in on a specific patch.

thanks,

greg k-h
