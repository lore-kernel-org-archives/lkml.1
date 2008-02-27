Return-Path: <linux-kernel-owner+w=401wt.eu-S1758191AbYB0NIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191AbYB0NIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 08:08:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755217AbYB0NIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 08:08:40 -0500
Received: from cavan.codon.org.uk ([78.32.9.130]:43585 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196AbYB0NIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 08:08:40 -0500
Date: Wed, 27 Feb 2008 13:08:20 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, len.brown@intel.com,
       linux-pm@lists.linux-foundation.org
Message-ID: <20080227130819.GA28528@srcf.ucam.org>
References: <20080224162309.3e67dd22.sfr@canb.auug.org.au> <47C1B52B.3080104@gmail.com> <200802242100.46474.rjw@sisk.pl> <47C1FF2E.4060600@gmail.com> <20080225092628.GA493@elf.ucw.cz> <47C35C53.5010609@gmail.com> <20080226214950.GD10280@elf.ucw.cz> <47C4AEB7.1030404@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C4AEB7.1030404@gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: broken suspend to ram with velocity driver
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 08:28:39PM -0400, Kevin Winchester wrote:
> I haven't done too much looking at what the tool on that site does,
> but I was under the impression that I should be able to do:
> 
> echo mem > /sys/power/state
> 
> and then bring the system back up and have it work.  

Not if you want video to come back on most hardware - the kernel has no 
idea how to reinitialise your graphics card. s2ram and similar tools 
attempt to deal with this by reprogramming it from userspace. On the 
other hand, if it did work on the same hardware with earlier kernels, 
then that's a bug.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
