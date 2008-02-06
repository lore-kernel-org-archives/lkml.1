Return-Path: <linux-kernel-owner+w=401wt.eu-S1762637AbYBFLUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762637AbYBFLUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 06:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759776AbYBFLUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 06:20:33 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52680 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753042AbYBFLUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 06:20:31 -0500
Date: Wed, 6 Feb 2008 12:08:05 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, bzolnier@gmail.com,
       linux-ide@vger.kernel.org
Subject: Re: 2.6.26-git0: IDE oops during boot
Message-ID: <20080206110805.GB3613@elf.ucw.cz>
References: <20080206105334.GA3664@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080206105334.GA3664@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-02-06 11:53:34, Pavel Machek wrote:
> Hi!
> 
> Trying to boot 2.6.25-git0 (few days old), I get
> 
> BUG: unable to handle kernel paging request at ffff..ffb0
> IP at init_irq+0x42e
> 
> Call trace:
> ide_device_add_all
> ide_generic_init
> kernel_init
> child_rip
> vgacon_cursor
> kernel_init
> child_rip
> 
> Excerpt from config:
> 
> CONFIG_IDE=y
> CONFIG_BLK_DEV_IDE=y

Disabling CONFIG_IDE made my machine boot, as it was using libata
anyway.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
