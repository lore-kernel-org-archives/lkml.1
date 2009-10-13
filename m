Return-Path: <linux-kernel-owner+w=401wt.eu-S1758787AbZJMCXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787AbZJMCXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 22:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758684AbZJMCXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 22:23:43 -0400
Received: from thunk.org ([69.25.196.29]:51877 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757688AbZJMCXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 22:23:42 -0400
Date: Mon, 12 Oct 2009 22:23:01 -0400
From: Theodore Tso <tytso@mit.edu>
To: Shawn Starr <shawn.starr@rogers.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.32-rc4] + EXT4 corruption
Message-ID: <20091013022301.GC2606@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Shawn Starr <shawn.starr@rogers.com>, linux-kernel@vger.kernel.org
References: <200910122207.50140.shawn.starr@rogers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910122207.50140.shawn.starr@rogers.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 10:07:49PM -0400, Shawn Starr wrote:
> Hello everyone, 
> 
> I somehow managed to corrupt some of my filesystem.
> 
> What I did was this:
> 
> in /etc/modprobe.d/alsa-base.conf (Kubuntu)
> 
> I added:
> 
> install snd-aloop /sbin/modprobe snd-aloop
> 
> Saved it, then ran, modprobe snd-aloop, the system started spawning
> many copies of modprobe, then machine started going though a swap
> storm, could not reboot safely, hit power button on laptop. When the
> system came back up, EXT4 greeted me with severe errors on some
> opened files. It did repair filesystem however. It corrupted some
> configuration files that were open at the time of the shutdown.
> 
> I'm guessing no matter how much you attempt to replay a journal you
> still can get corruption such as this?

You shouldn't get any file system corruption after replaying a
journal.  I'm trying to get an easily reproducible test case for this.
Can you give me more information about where your root filesystem is
located.  Is it using LVM?  dm-crypt?  Can you reliably reproducible
the file system corruption?

						- Ted


					
