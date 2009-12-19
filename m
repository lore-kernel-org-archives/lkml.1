Return-Path: <linux-kernel-owner+w=401wt.eu-S1753219AbZLSTGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbZLSTGI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 14:06:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbZLSTGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 14:06:01 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33476 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751973AbZLSTGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 14:06:00 -0500
Date: Sat, 19 Dec 2009 11:05:48 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jeff Garzik <jeff@garzik.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates
In-Reply-To: <20091219181350.GA21058@havoc.gtf.org>
Message-ID: <alpine.LFD.2.00.0912191102320.3712@localhost.localdomain>
References: <20091219181350.GA21058@havoc.gtf.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 19 Dec 2009, Jeff Garzik wrote:
> 
> to receive the following updates:
> 
>  drivers/ata/libata-scsi.c    |    2 +-
>  drivers/ata/libata-sff.c     |    2 +-
>  drivers/ata/pata_hpt3x2n.c   |   64 ++++++++++---------
>  drivers/ata/pata_octeon_cf.c |    2 +-
>  drivers/ata/sata_mv.c        |  144 ++++++++++++++++++++++++++++++++++++------
>  5 files changed, 163 insertions(+), 51 deletions(-)
>  mode change 100644 => 100755 drivers/ata/sata_mv.c

WTF is that mode change?

It's introduced by commit 6481f2b52cd5411ea6342b749daf0e4f3b390d7b: 
"sata_mv: add power management support for the platform driver", and it's 
totally nonsensical.

I fixed that crazy stuff when merging, but you should look at your own 
summaries a bit, and should have noticed that it was crazy. That file 
isn't an executable.

			Linus
