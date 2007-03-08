Return-Path: <linux-kernel-owner+w=401wt.eu-S1751532AbXCHMFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532AbXCHMFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 07:05:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbXCHMFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 07:05:44 -0500
Received: from hermes2.dur.ac.uk ([129.234.8.21]:33240 "EHLO hermes2.dur.ac.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbXCHMFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 07:05:43 -0500
Date: Thu, 8 Mar 2007 12:03:03 +0000
From: Ash Milsted <thatistosayiseenem@gawab.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Jeff Chua <jeff.chua.linux@gmail.com>, pavel@suse.cz,
       linux-pm@lists.osdl.org, lenb@kernel.org, linux-acpi@vger.kernel.org,
       "Michael S. Tsirkin" <mst@mellanox.co.il>, luming.yu@intel.com,
       Arkadiusz Miskiewicz <arekm@maven.pl>,
       Konstantin Karasyov <konstantin.a.karasyov@intel.com>, greg@kroah.com,
       linux-usb-devel@lists.sourceforge.net, Thomas Meyer <thomas.mey@web.de>,
       Meelis Roos <mroos@linux.ee>,
       Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>,
       Janosch Machowinski <jmachowinski@gmx.de>, vladimir.p.lebedev@intel.com,
       dmitry.torokhov@gmail.com, linux-input@atrey.karlin.mff.cuni.cz
Subject: Re: [2/6] 2.6.21-rc2: known regressions
Message-Id: <20070308120303.d285e4a3.thatistosayiseenem@gawab.com>
In-Reply-To: <45EE9D52.9060807@garzik.org>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
	<20070305015034.GG3441@stusta.de>
	<45EE9D52.9060807@garzik.org>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-DurhamAcUk-MailScanner: Found to be clean, Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Mar 2007 06:09:06 -0500
Jeff Garzik <jeff@garzik.org> wrote:

> Adrian Bunk wrote:
> > Subject    : AT keyboard only works with pci=noacpi
> > References : http://lkml.org/lkml/2007/3/3/68
> > Submitter  : Ash Milsted <thatistosayiseenem@gawab.com>
> > Status     : unknown
> 
> 
> sounds like a BIOS bug, even though it appears to be a regression?
> 

Resolved here:
http://marc.theaimsgroup.com/?l=linux-kernel&m=117332735404395&w=2

Was a bug in the i8042 driver it seems.

Ash
