Return-Path: <linux-kernel-owner+w=401wt.eu-S1753084AbZHGPkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbZHGPkL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 11:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbZHGPkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 11:40:11 -0400
Received: from kroah.org ([198.145.64.141]:44878 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbZHGPkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 11:40:10 -0400
Date: Fri, 7 Aug 2009 08:13:20 -0700
From: Greg KH <greg@kroah.com>
To: Al Boldi <a1426z@gawab.com>
Cc: Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>, gregkh@suse.de,
       Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
 /dev
Message-ID: <20090807151320.GA26639@kroah.com>
References: <20090805171513.GA10443@kroah.com>
 <200908070804.08156.a1426z@gawab.com>
 <20090807052015.GA24615@kroah.com>
 <200908071549.21416.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908071549.21416.a1426z@gawab.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 03:49:21PM +0300, Al Boldi wrote:
> Greg KH wrote:
> > It's much faster than udev, and is equivalent to a static /dev with the
> > exception that the group and permission settings that you are used to.
> > udev then needs to come along and make those settings, but that's so
> > frickin fast it's amazing.
> 
> Sounds great!
> 
> > So, test it out and see if you want to verify this.
> 
> Ok, can you post a patch against .30?

If you look in the lkml archives, the first versions of this were posted
against .30 if you wish to try them out.

thanks,

greg k-h
