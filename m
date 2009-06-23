Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbZFWUXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbZFWUXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 16:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbZFWUXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 16:23:10 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:56086 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbZFWUXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 16:23:09 -0400
Date: Tue, 23 Jun 2009 21:23:02 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Len Brown <lenb@kernel.org>
Cc: sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 2.6.32] Simple Firmware Interface (SFI): initial
	support
Message-ID: <20090623202302.GA15265@srcf.ucam.org>
References: <1245741246-6503-1-git-send-email-lenb@kernel.org> <20090623183153.GB12814@srcf.ucam.org> <alpine.LFD.2.00.0906231438190.23079@localhost.localdomain> <20090623185120.GA13824@srcf.ucam.org> <alpine.LFD.2.00.0906231541400.23079@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0906231541400.23079@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 04:00:55PM -0400, Len Brown wrote:

> But given that the hardware is fixed (it was fixed over a year ago),
> the question becomes what does ACPI mean on such a platform?
> It turns out that if you look at the ACPI spec and delete all the
> things that could not possibly apply to MRST, then you are left
> with very little.

Right, but instead you've effectively taken ACPI, done s/XSDT/SYST/ and 
then only supported a subset of the static tables and added some others. 
In return we gain two implementations to debug. I'm absolutely fine with 
the concept of a cut-down ACPI, but I'm pretty uncomfortable with it 
being implemented as a single-vendor spec. Right now SFI's a 
reimplementation of functionality we already have for the benefit of a 
single chipset, whereas instead it could have been a refactoring of the 
ACPI codebase to allow vendors to include whatever subset of the ACPI 
functionality they felt necessary.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
