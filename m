Return-Path: <linux-kernel-owner+w=401wt.eu-S1757293AbYAJFZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293AbYAJFZf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 00:25:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297AbYAJFZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 00:25:25 -0500
Received: from ip-163-246-113-216.pool.grokthis.net ([216.113.246.163]:1285
	"EHLO mail.mhcomputing.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751288AbYAJFZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 00:25:24 -0500
Date: Thu, 10 Jan 2008 05:25:20 +0000
From: Matthew Hall <mhall@mhcomputing.net>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: sata_nv does not function in kernel > 2.6.20.21
Message-ID: <20080110052520.GA9901@mhcomputing.net>
References: <20080110024733.GC9461@mhcomputing.net> <4785A1CF.7050006@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4785A1CF.7050006@garzik.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 11:40:47PM -0500, Jeff Garzik wrote:
> Error -16 is EBUSY, which causes the driver load to fail due to the "Unable 
> to reserve mem region" message.
>
> This means that the sata_nv driver needed to use PCI BAR 6, but was unable 
> to for some reason.  Given that sata_nv uses devres like other libata 
> drivers, IMO the likely cause is outside the ATA subsystem (PCI? ACPI?).

I will follow up on this with the appropriate subsystem lists ASAP. 
Thanks for getting me redirected appropriately.

> One workaround to try is setting sata_nv module option 'adma' to zero (0), 
> in the hopes that it ignores that final region and work anyway.

I am not quite sure what to do about this part... my boot device for the 
system is on one of the sata_nv channels which remains functional and 
does not get disabled by the resource conflict.

How shall I best attempt the suggested workaround without having to 
delete the sata_nv driver from the kernel thus rendering the kernel 
unbootable on this machine? Is there some way to pass the appropriate 
option at boot instead of at module load time or some file I could 
modify to enable the specified option in the code?

> 	Jeff

Thanks for the fast reply!
Matthew Hall
