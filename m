Return-Path: <linux-kernel-owner+w=401wt.eu-S965555AbXC1BQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965555AbXC1BQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 21:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965554AbXC1BQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 21:16:21 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:36400 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965552AbXC1BQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 21:16:20 -0400
Date: Wed, 28 Mar 2007 02:16:09 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       kyle@canonical.com
Message-ID: <20070328011608.GA26913@srcf.ucam.org>
References: <20070323191321.5d00887a@lxorguk.ukuu.org.uk> <20070328000851.GA25551@srcf.ucam.org> <20070328001610.GB25551@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070328001610.GB25551@srcf.ucam.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: ata_piix can't drive Mac hardware properly
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2007 at 01:16:10AM +0100, Matthew Garrett wrote:

> comment seems to be wrong (or, alternatively, it's the 
> ata_read_native_max_address_ext call that's failing and returning 
> garbage? I'll look into that)

It's ata_read_native_max_address_ext failing, and it's fine if I use 
ahci rather than ata_piix, so I'll just chalk this up to Apple's 
firmware being broken (again) and putting the hardware into some sort of 
"I can't believe it's not piix" mode and see what I can do about 
ensuring we use ahci instead.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
