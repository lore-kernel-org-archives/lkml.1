Return-Path: <linux-kernel-owner+w=401wt.eu-S1763144AbXHaA3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763144AbXHaA3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 20:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757228AbXHaA3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 20:29:25 -0400
Received: from cavan.codon.org.uk ([78.32.9.130]:50890 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757129AbXHaA3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 20:29:25 -0400
X-Greylist: delayed 2035 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Aug 2007 20:29:24 EDT
Date: Fri, 31 Aug 2007 00:55:19 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Message-ID: <20070830235519.GA17098@srcf.ucam.org>
References: <21d7e9970708270129u2a619b8dx79fbdaddc55fa16f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9970708270129u2a619b8dx79fbdaddc55fa16f@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: resume failing on ATA controller
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2007 at 06:29:48PM +1000, Dave Airlie wrote:

(I've already mentioned this to Dave, but for the benefit of anyone 
else)

> I also know someone running the same laptop using drivers/ide drivers
> whose suspend/resume works properly....
> 
> I'm running the latest Fedora rawhide kernel based on -rc3-git7

libata doesn't enable ACPI support by default. It needs the libata_acpi 
option enabled at boottime (libata.libata_acpi?) in order to execute the 
ACPI methods that HPs seem to need to resume properly. With that change, 
mine works fine.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
