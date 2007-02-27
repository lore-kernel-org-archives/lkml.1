Return-Path: <linux-kernel-owner+w=401wt.eu-S1752500AbXB0SyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbXB0SyH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 13:54:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbXB0SyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 13:54:07 -0500
Received: from mail.velocity.net ([66.211.211.55]:36280 "EHLO
	mail.velocity.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbXB0SyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 13:54:05 -0500
X-AV-Checked: Tue Feb 27 13:54:04 2007 clean
Subject: Re: sata_sil problems with recent kernels
From: Dale Blount <linux-kernel@dale.us>
To: linux-kernel@vger.kernel.org
Cc: linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>
In-Reply-To: <1172250027.15179.16.camel@dale.velocity.net>
References: <1172250027.15179.16.camel@dale.velocity.net>
Content-Type: text/plain
Date: Tue, 27 Feb 2007 13:54:04 -0500
Message-Id: <1172602444.5420.17.camel@dale.velocity.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-23 at 12:00 -0500, Dale Blount wrote:
> Hi,
> 
> Excuse me if this has been covered or fixed, I couldn't find anything in
> the archives.
> 
> I upgraded from 2.6.11.7 to 2.6.20.1 today and found all the drives
> connected to 2 brands of sata_sil sata controllers not working.  The
> drives are also (now) of various brands, Maxtor 300GB and 500GB
> Seagates.


I have some additional information coming from more testing and I also
CC'd linux-ide and Jeff Garzik.
Original message (with BUG) can be found here: 
http://permalink.gmane.org/gmane.linux.kernel/497140


I'm using my distro's modular kernel (ArchLinux).  The 2.6.19.x kernels
from the distro also have the problem.  However, Knoppix 5.1.1 which
ships with 2.6.19.1 detects all the drives on sata_sil controllers
without errors, and PLD linux live rescue CD (2.6.19.2) detects 2 of the
3 currently connected, the third is just absent, no BUG like when using
Arch.

I noticed Knoppix had sata_sil=y, so I tried building it in as well with
the same BUG results.

My .config (distro standard) can be found here:
http://tinyurl.com/yul8eu

I will be happy to test/provide more information on request.

Thanks again,

Dale

