Return-Path: <linux-kernel-owner+w=401wt.eu-S1753098AbXC1Va6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098AbXC1Va6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 17:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753115AbXC1Va6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 17:30:58 -0400
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:37956 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbXC1Va5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 17:30:57 -0400
Date: Wed, 28 Mar 2007 17:30:18 -0400
From: Kyle McMartin <kyle@canonical.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, kyle@canonical.com
Subject: Re: HPA patches
Message-ID: <20070328213017.GG4630@athena.road.mcmartin.ca>
References: <20070323191321.5d00887a@lxorguk.ukuu.org.uk> <20070328000851.GA25551@srcf.ucam.org> <20070328105754.72b578bd@the-village.bc.nu> <20070328200829.GA12776@srcf.ucam.org> <20070328225431.69d0a3cc@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070328225431.69d0a3cc@the-village.bc.nu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2007 at 10:54:31PM +0100, Alan Cox wrote:
> > Hm. I tried adding it in the eh code after ata_set_mode() in 
> > ata_eh_recover(), which alters the problem slightly - hpa_sectors is 
> > still 0, so the taskfile call is still failing, but now the system just 
> > stops at around the time that anything attempts to access sda with no 
> > errors other than
> 
> I wonder if the firmware is dying when we ask the disk to go zero sized
> rather than erroring politely. I'm not sure hth HPA sectors can come back
> as zero but we can be fairly sure 0 means "no HPA" in this case I guess ?
> 

The command is "Read Native Max Sectors" which should be the full disk
size as long as the command is supported, and the size returned by IDENTIFY
would be smaller if HPA was in use.

AIUI at least.

Cheers,
	Kyle
