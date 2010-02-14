Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab0BNQ5i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 11:57:38 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:35769 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab0BNQ5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 11:57:37 -0500
Date: Sun, 14 Feb 2010 16:57:35 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andreas Mohr <andi@lisas.de>
Cc: Erik Andren <erik.andren@gmail.com>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 1/1] platform/x86/dell-laptop: Add another Dell laptop
	to the DMI whitelist
Message-ID: <20100214165735.GB25624@srcf.ucam.org>
References: <1266144897-2681-1-git-send-email-erik.andren@gmail.com> <20100214154709.GA7271@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100214154709.GA7271@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 14, 2010 at 04:47:10PM +0100, Andreas Mohr wrote:
> Definitely not only this one. E.g. my Inspiron 8000 (P3/700) has (dmidecode):
> 
> Handle 0x0300, DMI type 3, 13 bytes
> Chassis Information
>         Manufacturer: Dell Computer Corporation
>         Type: Portable
> 
> which, if "Portable" happens to be "8", means that it would match.

8 should be portable, yes. 9 would be laptop (and 10 notebook), but I 
haven't seen any examples of those in Dells.

> So:
> - do all older matching machines grok this?

The dcdbas call should fail if they don't, so I think we're ok.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
