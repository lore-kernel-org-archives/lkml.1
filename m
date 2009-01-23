Return-Path: <linux-kernel-owner+w=401wt.eu-S1759525AbZAWAcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525AbZAWAcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 19:32:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754739AbZAWAcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 19:32:08 -0500
Received: from cantor.suse.de ([195.135.220.2]:46008 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754671AbZAWAcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 19:32:07 -0500
Date: Thu, 22 Jan 2009 16:30:34 -0800
From: Greg KH <gregkh@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, mingo@elte.hu, geert@linux-m68k.org,
       joern@logfs.org, lkml@davidb.org, kernel@linuxace.com,
       kay.sievers@vrfy.org, phillip@lougher.demon.co.uk, hch@infradead.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] Squashfs pull request for 2.6.29
Message-ID: <20090123003034.GA8141@suse.de>
References: <20090109211937.GA14342@logfs.org> <20090110124335.GB30744@elte.hu> <20090110165033.GA23943@logfs.org> <20090110101235.7ca24c44.akpm@linux-foundation.org> <20090110221528.GA31774@elte.hu> <Pine.LNX.4.64.0901111022590.30201@anakin> <20090111153920.GC7401@elte.hu> <20090111163018.GA9300@suse.de> <20090122215041.GA29369@redhat.com> <20090122161659.53de9e56.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090122161659.53de9e56.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 04:16:59PM -0800, Andrew Morton wrote:
> My question is: what is the process for moving things out of staging/ and
> into the kernel proper?  We don't want to be merging ex-crap code which has
> had its whitespace and wrappers cleaned up by a person who is not suitably
> experienced in the relevant subsystem.
> 
> It _should_ (I think) be "OK, this is ready for us to start reviewing". 
> ie: treat it as if it had just come in from a random new submitter.

I agree, and I will do just that.

> a) If that happens, who will be responding to the review comments?  Who
>    was the submitter?

For drivers that don't have an active developer, I'll handle the review
commends and fix things up.  Some of these drivers do have active
developers, and I'm sure they will be the ones handling the review as
well.

> b) What happens if it is then decided that we just don't want that code
>    in the tree at all?

As it's "just a driver", the odds of that happening are probably going
to be very slim.  We can cross that bridge when we come to it.

> c) Has any code yet made the transition out of staging and into the
>    kernel proper?  If so, which?

Not yet, but some of the network drivers are looking much better and I
think they will move out soon.

One of the v4l drivers should move out for .30, I need to get some time
to send the patch to those developers.

thanks,

greg k-h
