Return-Path: <linux-kernel-owner+w=401wt.eu-S1759026AbYH3Vvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759026AbYH3Vvq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 17:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756187AbYH3Vv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 17:51:27 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1158 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754829AbYH3Vv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 17:51:26 -0400
Date: Sat, 30 Aug 2008 15:15:48 +0200
From: Pavel Machek <pavel@suse.cz>
To: Thomas Renninger <trenn@suse.de>
Cc: ak@linux.intel.com, bjorn.helgaas@hp.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, linux-acpi@vger.kernel.org, ckornacker@suse.de
Subject: Re: Introduce interface to report BIOS bugs (reworked, FW_BUG simple solution)
Message-ID: <20080830131547.GB7862@ucw.cz>
References: <200808210919.07642.bjorn.helgaas@hp.com> <1219843631-26015-1-git-send-email-trenn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219843631-26015-1-git-send-email-trenn@suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-08-27 15:27:08, Thomas Renninger wrote:
> Even simplier, using FW_BUG define. I agree that the first implementation
> was over-designed, I somehow liked the printk_fw_err() and printk_fw_info()
> more, looked somehow more consistent with:
> 
> #define pr_info(fmt, arg...) \
>         printk(KERN_INFO fmt, ##arg)
> (and others).
> 
> Hmm, it shouldn't really matter.
> I wonder whether it works out that messages are hidden to the ordinary
> user with printk(KERN_INFO FW_BUG...).
> Something that vendors get an idea that they should not do this, but
> hiding it on a normally booted system is needed (but e.g. show it on a
> linuxfirmwarekit booted kernel).
> 
> printk(KERN_DEBUG FW_BUG...)
> Won't work because there you get too much output?
> Are these patches sufficient to achieve above?
> 
>       Thomas
> 
> PS: Forgot to add Pavel to CC who also commented on previous patches,
> it's work to do it right now, I expect you read this anyway.

Pavel listens, but sees no patch on either this or followup mail.

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
