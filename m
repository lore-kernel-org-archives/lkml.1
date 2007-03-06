Return-Path: <linux-kernel-owner+w=401wt.eu-S965150AbXCFPgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965150AbXCFPgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 10:36:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965157AbXCFPgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 10:36:23 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:46027 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965150AbXCFPgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 10:36:22 -0500
Date: Tue, 6 Mar 2007 10:36:20 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: ebuddington@wesleyan.edu, Oliver Neukum <oneukum@suse.de>
cc: USB development list <linux-usb-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] khubd and ent:sda1 sucking CPU with reiser4
 + USB HD
In-Reply-To: <200703060952.02291.oneukum@suse.de>
Message-ID: <Pine.LNX.4.44L0.0703061035030.3401-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2007, Oliver Neukum wrote:

> > Am Dienstag, 6. März 2007 05:13 schrieb Eric Buddington:
> > reiser4[khubd(163)]: commit_current_atom (fs/reiser4/txnmgr.c:1049)[nikita-3176]:
> > WARNING: Flushing like mad: 16384
> > reiser4[khubd(163)]: commit_current_atom (fs/reiser4/txnmgr.c:1049)[nikita-3176]:
> > WARNING: Flushing like mad: 32768
> > ...<many simiar messages>
> > 
> > Most problematically, khubd and ent:sda1! are conspiring to suck 100%
> > CPU time, even after powering off the drive. A bunch of processes are
> > stuck in 'D' state, possibly because they're trying to access the dead
> > disk, which won't umount ("device is busy").
> 
> It looks like khubd allocates memory and enters reiser4. Possibly we have
> GFP_KERNEL in khubd where we should have GFP_NOIO or reiser4 has
> a problem dealing with IO failures.

A more complete stack trace (for example, Alt-SysRq-T) would help.

Alan Stern

