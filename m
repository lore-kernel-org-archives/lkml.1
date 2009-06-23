Return-Path: <linux-kernel-owner+w=401wt.eu-S1754786AbZFWSvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbZFWSvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 14:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbZFWSvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 14:51:32 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:42679 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbZFWSvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 14:51:32 -0400
Date: Tue, 23 Jun 2009 19:51:20 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Len Brown <lenb@kernel.org>
Cc: sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 2.6.32] Simple Firmware Interface (SFI): initial
	support
Message-ID: <20090623185120.GA13824@srcf.ucam.org>
References: <1245741246-6503-1-git-send-email-lenb@kernel.org> <20090623183153.GB12814@srcf.ucam.org> <alpine.LFD.2.00.0906231438190.23079@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0906231438190.23079@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 02:41:28PM -0400, Len Brown wrote:
> On Tue, 23 Jun 2009, Matthew Garrett wrote:
> 
> > There seems to be a huge amount of overlap between SFI and ACPI.
> > Couldn't this have simply taken the form of some additional ACPI tables 
> > and a decoupling of ACPI enumeration from runtime AML interpretation? 
> > How final is this spec?
> 
> > I realise that we're pretty much constrained to implementing this if 
> > hardware actually ships with it, but it seems to be an additional 
> > firmware interface with no real benefit - as far as I can tell it's not 
> > possible for a platform to meaningfully implement both ACPI and SFI 
> > without duplicating information?
> 
> Please let me know if your questions are not thoroughly answered here:
> http://simplefirmware.org/faq

Yeah, I read that and it didn't really seem to clear things up. There's 
no especially meaningful reason for a specialised platform to include 
any AML code - the closest equivalent case I'm thinking of is "acpi=ht" 
where we parse some static ACPI tables but don't do any runtime 
interpretation. In this universe, SFI would simply have been some 
specced additional tables and a build option to include table parsing 
but not the interpreter.

I appreciate that if this is what's going to be on the hardware then 
we're stuck with it, but I'm hugely unconvinced that this couldn't have 
taken the form of "embedded ACPI" rather than an entire new firmware 
interface.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
