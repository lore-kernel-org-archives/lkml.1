Return-Path: <linux-kernel-owner+w=401wt.eu-S965409AbXA3FMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965409AbXA3FMf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 00:12:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965406AbXA3FMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 00:12:34 -0500
Received: from smtp.osdl.org ([65.172.181.24]:43227 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965398AbXA3FMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 00:12:32 -0500
Date: Mon, 29 Jan 2007 21:11:39 -0800
From: Andrew Morton <akpm@osdl.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: 2.6.20-rc6-mm3
Message-Id: <20070129211139.8d584d89.akpm@osdl.org>
In-Reply-To: <45BECEAB.4090201@garzik.org>
References: <20070129204528.eb8d695e.akpm@osdl.org>
	<45BECEAB.4090201@garzik.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jan 2007 23:50:51 -0500
Jeff Garzik <jeff@garzik.org> wrote:

> Andrew Morton wrote:
> > Temporarily at
> > 
> > 	http://userweb.kernel.org/~akpm/2.6.20-rc6-mm3/
> > 
> > Will appear later at
> > 
> > 	ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm3/
> > 
> > 
> > - Restored git-block.patch: mainly the block unplugging rework.  The
> >   problematic CFQ updates have been taken out.
> > 
> > - Restored the fsaio patches as a consequence.
> > 
> > - A huge ACPI update.
> > 
> > - A decent number of x86 patches have been temporarily dropped due to their
> >   clash against the ACPI update.
> > 
> > - A few problems reported against 2.6.20-rc6-mm2 have been fixed.
> 
> Now that kevent work has settled down, would you be open to including it 
> in -mm?
> 

I just haven't had the bandwidth to track what's been happening there
lately.  The two main things which need to be done are

-  a detailed line-by-line review

- for someone to gain a full understanding of the delta between <these
  patches> and <ulrich> and to explain these differences to mortals and to
  convince themselves and the rest of us that we're all OK.

