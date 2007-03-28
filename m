Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbXC1EHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbXC1EHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 00:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbXC1EHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 00:07:48 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:48366 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbXC1EHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 00:07:47 -0400
Date: Wed, 28 Mar 2007 05:07:35 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       kyle@canonical.com
Message-ID: <20070328040735.GA28824@srcf.ucam.org>
References: <20070323191321.5d00887a@lxorguk.ukuu.org.uk> <20070328000851.GA25551@srcf.ucam.org> <20070328001610.GB25551@srcf.ucam.org> <20070328011608.GA26913@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070328011608.GA26913@srcf.ucam.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: ata_piix can't drive Mac hardware properly
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2007 at 02:16:08AM +0100, Matthew Garrett wrote:

> It's ata_read_native_max_address_ext failing, and it's fine if I use 
> ahci rather than ata_piix, so I'll just chalk this up to Apple's 
> firmware being broken (again) and putting the hardware into some sort of 
> "I can't believe it's not piix" mode and see what I can do about 
> ensuring we use ahci instead.

Slightly oddly, with ata_piix it seems to be failing with AC_ERR_HSM. 
Any idea why that might be?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
