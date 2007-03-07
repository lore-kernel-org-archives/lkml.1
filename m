Return-Path: <linux-kernel-owner+w=401wt.eu-S2992439AbXCGSUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992439AbXCGSUQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 13:20:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992438AbXCGSUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 13:20:15 -0500
Received: from twinlark.arctic.org ([207.29.250.54]:42034 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992439AbXCGSUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 13:20:13 -0500
Date: Wed, 7 Mar 2007 10:20:12 -0800 (PST)
From: dean gaudet <dean@arctic.org>
To: Marc Perkel <mperkel@yahoo.com>
cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org
Subject: Re: Raid 10 Problems?
In-Reply-To: <708349.8753.qm@web52513.mail.yahoo.com>
Message-ID: <Pine.LNX.4.64.0703071010260.8538@twinlark.arctic.org>
References: <708349.8753.qm@web52513.mail.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Mar 2007, Marc Perkel wrote:

> 
> --- Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
> 
> > 
> > On Mar 4 2007 19:37, Marc Perkel wrote:
> > >> 
> > >>   -b internal -- seems like a good idea to speed
> > up
> > >>   resynchronization.
> > >
> > >I'm trying to figure out what the default is. 
> > 
> > -b none, meaning the whole drive will be
> > resynchronized when the
> > even counters don't match.
> > 
> >
> http://gentoo-wiki.com/HOWTO_Install_on_Software_RAID#Write-intent_bitmap
> > 
> > 
> 
> That information has been extremely useful. Thanks a
> lot. I fund a command to do the bitmap internal after
> the array was made so I added that. Seems like some of
> these features should be default. Maybe it's time for
> the raid folks to update what is default?

the bitmap has performance implications... for example:

http://www.mail-archive.com/linux-raid@vger.kernel.org/msg07229.html

i still prefer to use the bitmap -- i just make it external for devices 
which are busy.

note that unless you tweak your init scripts you'll need to put external 
bitmaps on your root partition, see this thread:

http://www.mail-archive.com/linux-raid@vger.kernel.org/msg06441.html

-dean
