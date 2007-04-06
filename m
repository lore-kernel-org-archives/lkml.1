Return-Path: <linux-kernel-owner+w=401wt.eu-S933120AbXDFWXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933120AbXDFWXv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 18:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933114AbXDFWXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 18:23:51 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:41174 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933120AbXDFWXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 18:23:50 -0400
Subject: Re: USB: on suspend to ram/disk all usb devices are replugged
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Pavel Machek <pavel@ucw.cz>
Cc: Chuck Ebbert <cebbert@redhat.com>, Alan Stern <stern@rowland.harvard.edu>,
       David Zeuthen <davidz@redhat.com>, Maxim <maximlevitsky@gmail.com>,
       Pete Zaitcev <zaitcev@redhat.com>, gregkh@suse.de,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
In-Reply-To: <20070402193606.GA3576@elf.ucw.cz>
References: <Pine.LNX.4.44L0.0704011422460.1054-100000@netrider.rowland.org>
	 <46114DAD.3060100@redhat.com>  <20070402193606.GA3576@elf.ucw.cz>
Content-Type: text/plain
Date: Sat, 07 Apr 2007 08:23:50 +1000
Message-Id: <1175898230.6481.87.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, 2007-04-02 at 21:36 +0200, Pavel Machek wrote:
> Hi!
> 
> > > But you're still likely to run into trouble if you unplug a storage
> > > device, move it to another system and write on it, then plug it back into
> > > the original system.  The PLVM would somehow have to recognize that the
> > > data had been changed.  I don't know a foolproof way of doing that.
> > > 
> > 
> > Mark the filesystem as in-use with a one-time UUID in the superblock at
> > mount time. If one moved the drive to another system it would require
> > an fsck to clear the UUID before the other system could use it; then
> > the original machine would refuse to use the drive when the UUID didn't
> > match on resume.
> 
> You still need fs-specific code, I'm afraid... plus userland tool
> to reset signatures back.

You don't need userland to reset the signatures. More kernel code, sure.
But it doesn't _need_ to be userland.

Regards,

Nigel

