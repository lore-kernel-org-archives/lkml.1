Return-Path: <linux-kernel-owner+w=401wt.eu-S1756589AbYHMObT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbYHMObT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 10:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754434AbYHMObG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 10:31:06 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55381 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754095AbYHMObE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 10:31:04 -0400
Date: Wed, 13 Aug 2008 10:31:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pavel Machek <pavel@suse.cz>
cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       <James.Bottomley@HansenPartnership.com>, <teheo@novell.com>,
       <oneukum@suse.de>
Subject: Re: Power management for SCSI
In-Reply-To: <20080813095055.GA475@elf.ucw.cz>
Message-ID: <Pine.LNX.4.44L0.0808131026320.2455-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008, Pavel Machek wrote:

> From: Alan Stern <stern@rowland.harvard.edu>
> 
> Add support for autosuspend/autoresume. Lowlevel driver can use it to
> spin the disk down and power down its SATA link, to turn off the USB
> interface, etc.
> 
> Spinning down the disk is useful - saves ~0.5W here. Powering down
> SATA controller is even better -- should save ~1W.
> 
> Now, I guess the patch will need to be split to small pieces for
> merge... I tried to rearrange it so that the documentation and hooks
> go before stuff that needs the hooks, and before Kconfig enabler. If
> it looks reasonably good, I'll split it into smaller pieces.

James had a number of objections to my original patch; you can read 
them here:

https://lists.linux-foundation.org/pipermail/linux-pm/2008-March/016849.html

I haven't had time yet to work on an improved version.

Alan Stern

