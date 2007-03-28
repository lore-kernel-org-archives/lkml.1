Return-Path: <linux-kernel-owner+w=401wt.eu-S965379AbXC1AQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965379AbXC1AQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 20:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965370AbXC1AQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 20:16:27 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:38280 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965365AbXC1AQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 20:16:26 -0400
Date: Wed, 28 Mar 2007 01:16:10 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       kyle@canonical.com
Message-ID: <20070328001610.GB25551@srcf.ucam.org>
References: <20070323191321.5d00887a@lxorguk.ukuu.org.uk> <20070328000851.GA25551@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070328000851.GA25551@srcf.ucam.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: HPA patches
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2007 at 01:08:52AM +0100, Matthew Garrett wrote:
> ata3.01: ata_hpa_resize 1: sectors = 234441648, hpa_sectors = 0
                                                                ^
Does this just indicate the lack of an hpa? If so, the

/* if no hpa, both should be equal */

comment seems to be wrong (or, alternatively, it's the 
ata_read_native_max_address_ext call that's failing and returning 
garbage? I'll look into that)

-- 
Matthew Garrett | mjg59@srcf.ucam.org
