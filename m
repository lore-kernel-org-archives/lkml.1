Return-Path: <linux-kernel-owner+w=401wt.eu-S1753648AbXLFNfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbXLFNfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 08:35:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbXLFNf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 08:35:28 -0500
Received: from mail.suse.de ([195.135.220.2]:37878 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964AbXLFNf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 08:35:27 -0500
From: Andreas Schwab <schwab@suse.de>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Matthew Wilcox <matthew@wil.cx>, linuxppc-dev@ozlabs.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH] pci: Fix bus resource assignment on 32 bits with 64b resources
References: <20071205064116.D849BDE10A@ozlabs.org>
	<1196911347.7033.15.camel@pasglop> <20071206063940.GA16474@kroah.com>
	<1196927934.7033.39.camel@pasglop>
	<20071206081628.GA15868@parisc-linux.org>
	<C608AAD4-29F7-4D5D-AA85-3B28CCCAADE5@kernel.crashing.org>
X-Yow: Feel th' WHIRLING BUFFERS buffing away all that stress...
 Years of ROAD TAR gently washing away...
Date: Thu, 06 Dec 2007 14:35:25 +0100
In-Reply-To: <C608AAD4-29F7-4D5D-AA85-3B28CCCAADE5@kernel.crashing.org> (Kumar
	Gala's message of "Thu\, 6 Dec 2007 07\:24\:12 -0600")
Message-ID: <jetzmwosiq.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala <galak@kernel.crashing.org> writes:

> How does gcc deal with glibc extension to allow people to add their  
> own specifiers?

It doesn't, gcc only knows about the standard specifiers.  But it also
defines attributes that check other formats, like its own asm_fprintf
format specs.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
