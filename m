Return-Path: <linux-kernel-owner+w=401wt.eu-S1753826AbZIGPRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbZIGPRw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 11:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbZIGPRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 11:17:52 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56276 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679AbZIGPRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 11:17:51 -0400
Date: Mon, 7 Sep 2009 16:17:27 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
       wanzongshun <mcuos.com@gmail.com>
Subject: Re: linux-next: manual merge of the trivial tree with the arm tree
Message-ID: <20090907151727.GD6538@flint.arm.linux.org.uk>
References: <20090907163201.72adc3f6.sfr@canb.auug.org.au> <alpine.LNX.2.00.0909071713210.23856@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0909071713210.23856@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 07, 2009 at 05:14:38PM +0200, Jiri Kosina wrote:
> On Mon, 7 Sep 2009, Stephen Rothwell wrote:
> 
> > Today's linux-next merge of the trivial tree got a conflict in
> > arch/arm/mach-w90x900/w90p910.c between commit
> > 35c9221acb133ecc9abd701a1fb6fa909d177a77 ("ARM: 5682/1: Add cpu.c and
> > dev.c and modify some files of w90p910 platform") from the arm tree and
> > commit 6f8fadf4a5c43f9f10f1910c71d8d9ff0b0a26ca ("trivial: remove
> > unnecessary semicolons") from the trivial tree.
> > 
> > The former commit moved the code changed by the latter into a different
> > file (arch/arm/mach-w90x900/cpu.c - and removed the old file).  Its not
> > important enough to fix it there (so I just removed this file), but maybe
> > the part of the trivial commit touching this file could be sent to the
> > arm maintainer.
> 
> Sure, here we go. Russel, could you please apply this on top of your 
> current tree? (I have already dropped the bits touching arch/arm from 
> trivial queue). Thanks.

I'll have to split it up further, since I keep each platform class who
choses to send their stuff via me in separate branches.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
