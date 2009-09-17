Return-Path: <linux-kernel-owner+w=401wt.eu-S1755474AbZIQN3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbZIQN3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 09:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754903AbZIQN33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 09:29:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:49493 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112AbZIQN32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 09:29:28 -0400
Date: Thu, 17 Sep 2009 06:29:09 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] Remove broken by design and by implementation devtmpfs
	maintenance disaster
Message-ID: <20090917132909.GB4779@kroah.com>
References: <m1y6oef08k.fsf@fess.ebiederm.org> <20090917125759.GA4045@kroah.com> <20090917140548.4e6ee596@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090917140548.4e6ee596@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 02:05:48PM +0100, Alan Cox wrote:
> On Thu, 17 Sep 2009 05:57:59 -0700
> Greg KH <greg@kroah.com> wrote:
> 
> > On Thu, Sep 17, 2009 at 01:23:39AM -0700, Eric W. Biederman wrote:
> > > 
> > > devtmpfs has numerous problems.  The once I see from a quick review.
> > 
> > <snip>
> > 
> > I'm confused, why did you not at least cc: Kay and I on this message, if
> > I was a paranoid person, I would think that you were somehow trying to
> > skirt around us for some unknown reason :(
> > 
> > I think Kay has raised the proper points already.
> 
> I've seen nacks from Christoph and from Eric and it seems Al Viro has yet
> to review devtmpfs. I'd like to see Al's opinion personally.

That's fine, but as it's just using the standard tmpfs interfaces that
other in-kernel virtual filesystems use, it shouldn't need that much
review.  The code is quite small as well, and I thought Al was still on
an extended vacation.

This code has been reviewed and posted numerous times for over 6 months
now, which should be plenty of time for us to be waiting for a review,
don't you?

thanks,

greg k-h
