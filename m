Return-Path: <linux-kernel-owner+w=401wt.eu-S1759749AbXGXPr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759749AbXGXPr3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 11:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751881AbXGXPrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 11:47:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53665 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbXGXPrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 11:47:22 -0400
Date: Tue, 24 Jul 2007 17:47:20 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Olaf Hering <olh@suse.de>, Tilman Schmidt <tilman@imap.cc>,
       LKML <linux-kernel@vger.kernel.org>, nix.or.die@googlemail.com,
       andi@firstfloor.org
Subject: Re: 2.6.22-git17 boot failure
Message-ID: <20070724154720.GA29905@one.firstfloor.org>
References: <46A4C081.6070305@goop.org> <46A504A3.3070205@imap.cc> <46A51079.5030006@goop.org> <46A53396.2060902@imap.cc> <46A5444D.4080304@goop.org> <20070724091018.GA26724@one.firstfloor.org> <20070724095614.GB625@suse.de> <46A5D619.5030600@imap.cc> <20070724134516.GA2930@suse.de> <46A61E85.6050605@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A61E85.6050605@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2007 at 08:45:09AM -0700, Jeremy Fitzhardinge wrote:
> Olaf Hering wrote:
> > It seems the modules are not loaded at all in initrd, I dont see the
> > 'SCSI subsystem initialized' message for example.
> 
> Yes.  It's not clear to me whether that's because module loading is
> failing for some reason, or pci bus probing.  And completely unclear to
> me why CONFIG_XEN should make a difference.

Tilman can you double check you did make modules_install / mkinitrd 
properly and that mkinitrd uses the correct modules?

-Andi
