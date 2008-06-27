Return-Path: <linux-kernel-owner+w=401wt.eu-S1760694AbYF0TeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760694AbYF0TeZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 15:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757023AbYF0TeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 15:34:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38415 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756575AbYF0TeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 15:34:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Soeren Sonnenburg <kernel@nn7.de>
Subject: Re: 2.6.26-rc7: BUG at kernel/power/snapshot.c:493
Date: Fri, 27 Jun 2008 21:35:44 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
References: <1214584985.22228.15.camel@localhost> <200806271907.29968.rjw@sisk.pl> <1214590455.22228.16.camel@localhost>
In-Reply-To: <1214590455.22228.16.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806272135.44624.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 27 of June 2008, Soeren Sonnenburg wrote:
> On Fri, 2008-06-27 at 19:07 +0200, Rafael J. Wysocki wrote:
> > On Friday, 27 of June 2008, Soeren Sonnenburg wrote:
> > > Dear all,
> > > 
> > > Anyone else seeing this? Happened after resuming from s2both (from
> > > disk)...
> > 
> > At what point exactly did it happen?
> 
> I am attaching the full dmesg.

This looks like userland resume trying to feed invalid image metadata to the
kernel through /dev/snapshot.

Hard to say why this happened, though.  It looks like the swap header of the
resume device wasn't restored correctly after reading the image and that would
be a user space bug.

Thanks,
Rafael
