Return-Path: <linux-kernel-owner+w=401wt.eu-S934818AbXGXJKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934818AbXGXJKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 05:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759334AbXGXJKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 05:10:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43293 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757822AbXGXJKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 05:10:21 -0400
Date: Tue, 24 Jul 2007 11:10:18 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Tilman Schmidt <tilman@imap.cc>, LKML <linux-kernel@vger.kernel.org>,
       andi@firstfloor.org, nix.or.die@googlemail.com, olh@suse.de
Subject: Re: 2.6.22-git17 boot failure
Message-ID: <20070724091018.GA26724@one.firstfloor.org>
References: <46A3EC92.3050504@imap.cc> <46A3FBB7.9000608@imap.cc> <46A46BF9.6010906@goop.org> <46A481FD.2030607@imap.cc> <46A4C081.6070305@goop.org> <46A504A3.3070205@imap.cc> <46A51079.5030006@goop.org> <46A53396.2060902@imap.cc> <46A5444D.4080304@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A5444D.4080304@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, Jul 23, 2007 at 05:14:05PM -0700, Jeremy Fitzhardinge wrote:
> Well, it looks to me like it all falls over once it hits usermode;
> everything up till then is identical (except for the Xen-related
> initcalls which naturally don't exist in the non-Xen case).
> 
> I'm at a loss.  I don't know if there's some way to debug the initrd in
> more detail.  I suspect that its failing all PCI probing, rather being a
> specific SCSI/AHCI problem (since none of the other messages appear either).
> 
> Does the Xen case just hang, or reboot, or what?  The kernel messages
> just appear to stop.  I'd expect it to at least complain about not
> mounting the root filesystem or something.
> 
> Andi, any thoughts about how to debug the suse boot sequence?

Hmm, you could add a set -x into the startup script /sbin/mkinitrd
generates. But some work also happens with udev in the background.

Or let's ask Olaf, he's the expert on that

-Andi
