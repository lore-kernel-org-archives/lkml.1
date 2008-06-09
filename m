Return-Path: <linux-kernel-owner+w=401wt.eu-S1757478AbYFIBsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbYFIBsc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 21:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755222AbYFIBsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 21:48:23 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:60870 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923AbYFIBsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 21:48:22 -0400
Date: Mon, 9 Jun 2008 02:48:18 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] libata: Handle bay devices in dock stations
Message-ID: <20080609014818.GA32083@srcf.ucam.org>
References: <20080528143857.GB5585@homac.suse.de> <4845886E.2010505@garzik.org> <20080603181346.GA5013@srcf.ucam.org> <484C8AE1.3010908@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <484C8AE1.3010908@gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2008 at 10:44:01AM +0900, Tejun Heo wrote:

> TF-based ATA controllers are very sensitive to how the registers are 
> accessed and sometimes lock up the whole machine when they are not happy 
> by indefinitely holding the PCI bus.  This could have been the case if 
> IOs were in flight when the dock event occurred.  Were they?

I'd stopped hal, so I can't imagine that userspace was causing any to be 
generated at that point.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
