Return-Path: <linux-kernel-owner+w=401wt.eu-S1755191AbZIOU1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbZIOU1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 16:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbZIOU1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 16:27:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48391 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbZIOU1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 16:27:37 -0400
Date: Tue, 15 Sep 2009 13:24:45 -0700
From: Greg KH <gregkh@suse.de>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/20] mem_class: use minor as index instead of
 searching  the array
Message-ID: <20090915202445.GC3411@suse.de>
References: <20090915181247.GA32167@kroah.com>
 <1253041976-1111-6-git-send-email-gregkh@suse.de>
 <1253043763.11643.358.camel@desktop>
 <ac3eb2510909151246r59decb10pfb68fd5c0cb9a63a@mail.gmail.com>
 <1253045229.11643.398.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253045229.11643.398.camel@desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 01:07:09PM -0700, Daniel Walker wrote:
> On Tue, 2009-09-15 at 21:46 +0200, Kay Sievers wrote:
> > On Tue, Sep 15, 2009 at 21:42, Daniel Walker <dwalker@fifo99.com> wrote:
> > > On Tue, 2009-09-15 at 12:12 -0700, Greg Kroah-Hartman wrote:
> > >> +static const struct memdev {
> > >> +       const char *name;
> > >> +       const struct file_operations *fops;
> > >> +       struct backing_dev_info *dev_info;
> > >> +} devlist[] = {
> > >> +       [ 1] = { "mem", &mem_fops, &directly_mappable_cdev_bdi },
> > >
> > > This patch has several checkpatch errors wrt. the spacing used in the
> > > array index..
> > >
> > > Kay, can you send a follow up patch to correct them?
> > 
> > I think they are fine, and properly aligned to be best readable.
> 
> We already have a coding style in Linux which doesn't allow this type of
> alignment .. If we allowed everyone to pick their own coding style we
> would have a pretty ugly looking kernel.. That's why the checkpatch tool
> was create to test for style conformance.. If you feel strongly about
> this alignment you could change checkpatch not to warn on this , but I
> don't think it's likely a change like that would be accepted..

I explicitly ignored the checkpatch warnings here, as Kay is right, it
does look better and is more sane with the way he wrote it.

Remember, checkpatch.pl is a _guide_ not a
hard-and-fast-rule-or-else-puppies-will-get-hurt type of a thing.

The whole reason for having a consistant coding style is so your brain
gets used to patterns and you can see the context of the code instead.
It's a proven thing.  Arguing that removing that space makes it easier
to understand and maintain over time is illogical.

thanks,

greg k-h
