Return-Path: <linux-kernel-owner+w=401wt.eu-S1756279AbZHMWa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279AbZHMWa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 18:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755447AbZHMWa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 18:30:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59567 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755316AbZHMWa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 18:30:26 -0400
Date: Thu, 13 Aug 2009 15:29:12 -0700
From: Greg KH <gregkh@suse.de>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, linux-kernel@vger.kernel.org,
       stable@kernel.org, stable-review@kernel.org,
       Len Brown <len.brown@intel.com>
Subject: Re: [patch 28/74] thinkpad-acpi: fix incorrect use of
 TPACPI_BRGHT_MODE_ECNVRAM
Message-ID: <20090813222912.GA9108@suse.de>
References: <20090813194935.985368088@mini.kroah.org>
 <20090813195128.703325684@mini.kroah.org>
 <200908140006.45800.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908140006.45800.s.L-H@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 14, 2009 at 12:06:43AM +0200, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On Thursday 13 August 2009, Greg KH wrote:
> > 2.6.30-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> > 
> > commit 59fe4fe34d7afdf63208124f313be9056feaa2f4 upstream.
> > 
> > HBRV-based default selection of backlight control strategy didn't work
> > well, at least the X41 defines it but doesn't use it and I don't think
> > it will stop there.
> > 
> > Switch to a white/blacklist.  All models that have HBRV defined have
> > been included in the list, and initially all ATI GPUs will get
> > ECNVRAM, and the Intel GPUs will get UCMS_STEP.
> > 
> > Symptoms of incorrect backlight mode selection are:
> > 
> > 1. Non-working backlight control through sysfs;
> > 
> > 2. Backlight gets reset to the lowest level at every shutdown, reboot
> >    and when thinkpad-acpi gets unloaded;
> > 
> > This fixes a regression in 2.6.30, bugzilla #13826
> 
> As already reported in [1] and confirmed by hmh in [2], this patch breaks 
> compiling thinkpad_acpi in 2.6.31-rc5.

My appologies, I forgot to remove this one from the tree.  I'll go do so
right now.

thanks,

greg k-h
