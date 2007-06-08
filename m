Return-Path: <linux-kernel-owner+w=401wt.eu-S968630AbXFHIFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968630AbXFHIFK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 04:05:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968217AbXFHHcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:32:05 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43737 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968313AbXFHHcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:32:03 -0400
Date: Fri, 8 Jun 2007 00:31:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
Cc: Peter Jones <pjones@redhat.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1
Message-Id: <20070608003118.b8334635.akpm@linux-foundation.org>
In-Reply-To: <20070607161525.GA18363@suse.de>
References: <1181168095.3612.4.camel@lov.localdomain>
	<4667C47C.2010207@googlemail.com>
	<1181206091.3625.9.camel@lov.localdomain>
	<4667D2DF.30207@googlemail.com>
	<1181228660.3625.23.camel@lov.localdomain>
	<46682385.1060802@redhat.com>
	<20070607154342.GA16911@suse.de>
	<20070607085200.f8d6e2d3.akpm@linux-foundation.org>
	<20070607155953.GA17591@suse.de>
	<20070607090632.cfcf02e6.akpm@linux-foundation.org>
	<20070607161525.GA18363@suse.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007 09:15:25 -0700 Greg KH <gregkh@suse.de> wrote:

> On Thu, Jun 07, 2007 at 09:06:32AM -0700, Andrew Morton wrote:
> > On Thu, 7 Jun 2007 08:59:53 -0700 Greg KH <gregkh@suse.de> wrote:
> > 
> > > On Thu, Jun 07, 2007 at 08:52:00AM -0700, Andrew Morton wrote:
> > > > On Thu, 7 Jun 2007 08:43:42 -0700 Greg KH <gregkh@suse.de> wrote:
> > > > 
> > > > > >  Fixed in mkinitrd-6.0.9-6 , which I'll build now and push to 
> > > > > >  updates-testing.  Thanks for getting my attention here.
> > > > > 
> > > > > Great, Andrew, can you please reenable the block-device patch that is in
> > > > > my tree now that the problem has been solved?
> > > > 
> > > > I think we're screwed, aren't we?  Everyone needs to upgrade mkinitrd to be
> > > > able to boot the kernel?  Not viable :(
> > > > 
> > > > For example, what about my two-year-old yellowdog machine?
> > > 
> > > Enable CONFIG_SYSFS_DEPRECATED and it should all work just fine.  That's
> > > what Michal said worked for him.
> > > 
> > 
> > Actually, it _was_ enabled.
> > 
> > Ho hum, I'll have a poke at it this evening.
> 
> Yeah, that sounds odd, it should have worked.

yup, yellowdog 4.1 on a mac g5:

gregkh-driver-block-device.patch applied, CONFIG_SYSFS_DEPRECATED=y:
	http://userweb.kernel.org/~akpm/s5000552.jpg

gregkh-driver-block-device.patch applied, CONFIG_SYSFS_DEPRECATED=n:
	Can't open /dev/sdb6  (root partition)

gregkh-driver-block-device.patch not applied, CONFIG_SYSFS_DEPRECATED=y:
	Happy camper

gregkh-driver-block-device.patch not applied, CONFIG_SYSFS_DEPRECATED=n:
	Still happy



