Return-Path: <linux-kernel-owner+w=401wt.eu-S1761835AbYHFIbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761835AbYHFIbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 04:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbYHFIbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 04:31:33 -0400
Received: from brick.kernel.dk ([87.55.233.238]:1466 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028AbYHFIbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 04:31:32 -0400
Date: Wed, 6 Aug 2008 10:31:29 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Michael Brennan <brennan.brisad@gmail.com>
Cc: linux-kernel@vger.kernel.org, rjw@sisk.pl, matthew@wil.cx,
       htejun@gmail.com, jeff@garzik.org
Subject: Re: Waking up from suspend regression
Message-ID: <20080806083129.GC20055@kernel.dk>
References: <200808060325.54537.brennan.brisad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808060325.54537.brennan.brisad@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06 2008, Michael Brennan wrote:
> Hi,
> 
> I am having some major problems with the newest kernels on my Thinkpad R61i 
> and I'm doing my best trying to debug the problems.
> 
> One problem is waking up from suspend to RAM. Earlier kernels worked fine 
> (e.g. 2.6.25), but with the latest the system is unusable after waking up.
> When trying to wake the computer up it first is completely unresponsive with a 
> black screen. After about 40 seconds it comes back alive and shows the locked 
> screensaver. But whatever I do I just get error messages, trying to unlock 
> the screen, it says authentication failed for some reason. If I try to log in 
> from console I just get kernel messages about I/O errors from the SATA HDD.
> 
> I have bisected this and get this behavior after the patch: 
> [ce6fce4295ba727b36fdc73040e444bd1aae64cd] PCI MSI: Don't disable MSIs if the 
> mask bit isn't supported

Same here, sata is dead after the resume. Thinkpad X60.

-- 
Jens Axboe

