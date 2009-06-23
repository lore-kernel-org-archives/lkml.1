Return-Path: <linux-kernel-owner+w=401wt.eu-S1756789AbZFWWfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789AbZFWWfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 18:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753625AbZFWWex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 18:34:53 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:51942 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbZFWWew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 18:34:52 -0400
Date: Tue, 23 Jun 2009 18:34:37 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, sfi-devel@simplefirmware.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 2.6.32] Simple Firmware Interface (SFI): initial support
In-reply-to: <20090623222319.5f44332a@lxorguk.ukuu.org.uk>
Message-id: <alpine.LFD.2.00.0906231820380.32098@localhost.localdomain>
References: <1245741246-6503-1-git-send-email-lenb@kernel.org>
 <20090623183153.GB12814@srcf.ucam.org>
 <alpine.LFD.2.00.0906231438190.23079@localhost.localdomain>
 <20090623185120.GA13824@srcf.ucam.org>
 <alpine.LFD.2.00.0906231541400.23079@localhost.localdomain>
 <20090623202302.GA15265@srcf.ucam.org> <20090623204524.GA15891@srcf.ucam.org>
 <20090623222319.5f44332a@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> > not enthusiastic about seeing this presented as a fait accompli in 
> > generic driver code, rather than under arch/x86/moorestown.
> 
> Certainly wouldn't be a real problem if it started there and migrated
> if/when it proves to be more generic.

There are no drivers in drivers/sfi/, nor will there ever be.

I followed the broken topology used by ACPI, which has both drivers
and non-driver-platform-dependent-code in drivers/acpi/.

I did propose fixing ACPI at one point, but there was no consensus
on where platform dependent non-driver code that runs on multiple
architectures should live.  (eg, where to put drivers/acpi/acpica/*)

SFI is largely in the same boat.  Though one could argue
that all of SFI could live under arch/x86 someplace,
though it will be accessed by more than moorestown specific code.

cheers,
-Len Brown, Intel Open Source Technology Center

